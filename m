Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbXLUOqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbXLUOqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 09:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbXLUOqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 09:46:14 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:57335 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbXLUOqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 09:46:14 -0500
Date: Fri, 21 Dec 2007 08:46:06 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Morgan <morgan@kernel.org>, serue@us.ibm.com,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       minslinux-mm@kvack.org
Subject: Re: [RFC] [PATCH -mm] oom_kill: remove uid==0 checks
Message-ID: <20071221144606.GC27197@sergelap.austin.ibm.com>
References: <20071212211835.GA24943@sergelap.austin.ibm.com> <47606969.6060808@kernel.org> <20071220163442.d93210ea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220163442.d93210ea.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Wed, 12 Dec 2007 15:06:17 -0800
> Andrew Morgan <morgan@kernel.org> wrote:
> 
> > Serge E. Hallyn wrote:
> > > Andrew, I've cc:d you here bc in doing this patch I noticed that your
> > > 64-bit capabilities patch switched this code from an explicit check
> > > of cap_t(p->cap_effective) to using __capable().  That means that
> > > now being glossed over by the oom killer means PF_SUPERPRIV will
> > > be set.  Is that intentional?
> > 
> > Yes, I switched the check because the old one didn't work with the new
> > capability representation.
> > 
> > However, I had not thought this aspect of this replacement through. At
> > the time, it seemed obvious but in this case it actually depends on
> > whether you think using privilege (PF_SUPERPRIV) means "benefited from
> > privilege", or "successfully completed a privileged operation".
> > 
> > I suspect, in this case, the correct thing to do is add the equivalent of:
> > 
> > #define CAPABLE_PROBE_ONLY(a,b)   (!security_capable(a,b))
> > 
> > and use that in the code in question. That is, return to the old
> > behavior in a way that will not break if we ever need to add more bits.

Oh, I'm sorry - Andrew Morgan, I somehow read that email to say you were
going to post such a patch, and let it fall off my todo list.  Should I
go ahead and post a patch or do you have one ready?

> I'm struggling to understand whether the above was an ack, a nack or a
> quack.
> 
> > Thanks for finding this.
> 
> >From that I'll assume ack ;)

It actually wasn't an ack of my patch.  But I'm not sure where to look
for that.

thanks,
-serge
