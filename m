Return-Path: <linux-kernel-owner+w=401wt.eu-S934357AbYEUPGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357AbYEUPGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758301AbYEUPFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:05:54 -0400
Received: from ns1.coraid.com ([12.51.113.4]:24435 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754401AbYEUPFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:05:54 -0400
X-Greylist: delayed 942 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2008 11:05:54 EDT
Date: Wed, 21 May 2008 10:49:24 -0400
From: "Ed L. Cashin" <ecashin@coraid.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthias Kaehlcke <matthias@kaehlcke.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ATA over Ethernet: Convert emsgs_sema in a completion
Message-ID: <20080521144924.GD22566@coraid.com>
References: <20080516191133.GI24569@traven> <20080519165122.9d94cc1c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519165122.9d94cc1c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 04:51:22PM -0700, Andrew Morton wrote:
> On Fri, 16 May 2008 21:11:33 +0200
> Matthias Kaehlcke <matthias@kaehlcke.net> wrote:
> 
> > @@ -216,7 +217,7 @@ aoechr_read(struct file *filp, char __user *buf, size_t cnt, loff_t *off)
> >  
> >  		spin_unlock_irqrestore(&emsgs_lock, flags);
> >  
> > -		n = down_interruptible(&emsgs_sema);
> > +		n = wait_for_completion_interruptible(&emsgs_comp);
> 
> Patch looks OK, but I worry about this code.  Suppose a signal is sent
> and we return to userspace with the complete() still outstanding.  Then
> someone removes the module.  
> 
> Perhaps there is synchronisation code which prevents that crash?

I plan to answer this question soon.  Right now I am quite busy.

This emsgs_sema part of the aoe driver has never caused any problems
for users but has caused many problems for me, because it is tricky to
think about, to talk about, and for others to patch.

I hope that there is a more straightforward way to get the current
read-from-the-file-forever behavior using an existing kernel
facility.  A user currently can do,

  cat /dev/etherd/err

... and have it block, waiting until there is an error to report,
printing it, and then blocking again, like reading from a pipe.

-- 
  Ed L Cashin <ecashin@coraid.com>
