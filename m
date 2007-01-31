Return-Path: <linux-kernel-owner+w=401wt.eu-S932942AbXAaKVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942AbXAaKVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 05:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932948AbXAaKVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 05:21:36 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:55488 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932942AbXAaKVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 05:21:36 -0500
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jan 2007 05:21:35 EST
Date: Wed, 31 Jan 2007 11:14:44 +0100 (MET)
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] question on resume()
User-Agent: KMail/1.9.1
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.name>, pm list <linux-pm@lists.osdl.org>,
       linux-kernel@vger.kernel.org
References: <200701291206.39637.oneukum@suse.de>
 <200701311004.19477.oneukum@suse.de> <20070131093653.GA19643@elf.ucw.cz>
In-Reply-To: <20070131093653.GA19643@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701311114.55685.oliver@neukum.org>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GP
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 31. Januar 2007 10:36 schrieb Pavel Machek:
> Hi!
> 
> > > Yes, it will.  The process freezer can only return success if there are no more
> > > TASK_UNINTERRUPTIBLE tasks.  Otherwise it fails (after a timeout).
> > 
> > So, this means, on suspend():
> > 
> > 1. Don't worry about TASK_UNINTERRUPTIBLE
> > 2. Do worry about TASK_INTERRUPTIBLE
> > We have to cease IO and must not call wake_up_interruptible()
> 
> "cease IO"? No, I believe it is enough not to start new I/O. Userspace
> is frozen at that point, it can't ask you to do I/O.
>
> > Isn't that a race until suspend() is called?
> 
> I do not think so.

What about URBs in flight which are waited for with TASK_INTERRUPTIBLE?

> > On resume():
> > 
> > 1. Don't worry about TASK_UNINTERRUPTIBLE
> > 2. Do not restart IO that may call wake_up_interruptible()
> > 
> > When do we restart such IO?
> 
> We reuse signal handling code to do that for us. It is same situation
> as when someone signals task doing I/O.

What happens to tasks in TASK_INTERRUPTIBLE which are frozen?
Are they interrupted and frozen?

	Regards
		Oliver
