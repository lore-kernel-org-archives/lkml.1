Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbZAIPVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbZAIPVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 10:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbZAIPVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 10:21:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46479 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbZAIPVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 10:21:31 -0500
Subject: Re: audit: EXECVE record - removed bogus newline
From: Eric Paris <eparis@redhat.com>
To: Jiri Pirko <jpirko@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
       viro@zeniv.linux.org.uk, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090109132130.0bc87c02@psychotron.englab.brq.redhat.com>
References: <20090108153829.7d063a4b@psychotron.englab.brq.redhat.com>
	 <1231428798.31089.80.camel@localhost.localdomain>
	 <20090109132130.0bc87c02@psychotron.englab.brq.redhat.com>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 10:21:25 -0500
Message-Id: <1231514485.25714.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-09 at 13:21 +0100, Jiri Pirko wrote:
> On Thu, 08 Jan 2009 10:33:18 -0500
> Eric Paris <eparis@redhat.com> wrote:
> 
> > On Thu, 2009-01-08 at 15:38 +0100, Jiri Pirko wrote:
> > > EXECVE records contain a newline after every argument. auditd converts
> > > "\n" to " " so you cannot see newlines even in raw logs, but they're
> > > there nevertheless. If you're not using auditd, you need to work round
> > > them. These '\n' chars are can be easily replaced by spaces when
> > > creating record in kernel. Note there is no need for trailing '\n' in
> > > an audit record. 
> > 
> > While I completely agree the \n was my mistake and should be
> > dropped/fixed can you fix one more thing and look at another?  First
> > arg_num_len is being miscalculated since I included the \n in that
> > calculation (might be the only place....)
> I think that calculation is correct only the comment needs to be changed like this:
> -       /* how many digits are in arg_num? 3 is the length of a=\n */
> +       /* how many digits are in arg_num? 3 is the length of " a=" */
> 
> the count is still 3 - with '\n' or with ' '.

You're right.  Sorry, I'd like to see the comment fixed.  That 3 does
matter and I don't want to see someone not realize how important getting
that len right is....

> > and I remember not wanting to
> > follow convention and put the space at the beginning of the aX= for some
> > reason.  If you add thousands of arguments so this is larger than
> > MAX_EXECVE_AUDIT_LEN do you end up with an extra space somewhere in the
> > second EXECVE record? 
> Is this a problem? We can do some workaround but is it necessary?

I'll go ahead and vote I don't care, even though I brought it up.  My
code left an extra space at the end of the record.  Yours puts it at the
beginning.  From the point of view of auditd the spaces don't mean
anything, so I'm ok with your method.  I guess it saves a call to
audit_log_format, and saving a call is benefit enough

Don't care if it's this window or the next, it's been like this for 3
weeks short of a year now  :)

Acked-by: Eric Paris <eparis@redhat.com>

