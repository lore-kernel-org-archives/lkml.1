Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbZI3P1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbZI3P1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbZI3P1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:27:08 -0400
Received: from adelie.canonical.com ([91.189.90.139]:50373 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbZI3P1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:27:06 -0400
Date: Wed, 30 Sep 2009 16:27:08 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Daniel Walker <dwalker@fifo99.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/5] checkpatch: add a blacklist
Message-ID: <20090930152708.GD2957@shadowen.org>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
 <4AB86ED1.1040200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB86ED1.1040200@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 02:29:37PM +0800, Li Zefan wrote:
> Daniel Walker wrote:
> > There are times when maintainers intentially don't follow the coding
> > style. When that happens it means some errors need to be ignored, so
> > that other errors can be focused on.
> > 
> > To handle that I added a blacklist to checkpatch. The blacklist holds the
> > file names and errors which are ignored. The output is modified to
> > remove the errors from the list and not to count them.
> > 
> > When the blacklist kicks in there is a note that does list how many
> > errors got removed and that it was due to a blacklist entry. There is
> > also a new option "--noblacklist" that allows the errors to be added
> > back as it was without the blacklist.
> > 
> 
> So, for this piece of code:
> 
> TRACE_EVENT(...
> 
> 	TP_fast_assign(
> 		__entry->foo = bar( xxx );
> 	),
> )
> 
> checkpatch won't report the spaces inside bar()?
> If so, I don't like this patch.
> 
> Could you just teach checkpatch to recognize those macros used
> in TRACE_EVENT(), if those coding-style "errors" bother you
> so much that you can't put up with them?


Yeah I think that blanket ignoring spacing throughout the file seems
dangerous.  If these are going to show up a lot then it seems more sensible
to special case TRACE_EVENT or whatever is triggering the actual 'false'
matches.  I also suspect the 'this should never get long' argument will
not be true.  Once you can have an exception people will add them all over

Care to share an example of a change which is triggereing so we can
better target the exception.

-apw
