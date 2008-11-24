Return-Path: <linux-kernel-owner+w=401wt.eu-S1752975AbYKXELu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbYKXELu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 23:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYKXELm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 23:11:42 -0500
Received: from ozlabs.org ([203.10.76.45]:44027 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbYKXELl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 23:11:41 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: linux-next: rr tree build failure
Date: Mon, 24 Nov 2008 14:41:32 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: Greg KH <gregkh@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel@vger.kernel.org, katzj@redhat.com
References: <20081121141913.90d05091.sfr@canb.auug.org.au> <20081122064132.GA6196@suse.de> <20081122102952.50ec43ce.zaitcev@redhat.com>
In-Reply-To: <20081122102952.50ec43ce.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811241441.33180.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 November 2008 03:59:52 Pete Zaitcev wrote:
> On Fri, 21 Nov 2008 22:41:32 -0800, Greg KH <gregkh@suse.de> wrote:
> > > FYI, if Pete had discovered this __setup issue today, the correct fix
> > > would be:
> > > 1) core_param(nousb) for backwards compat.
> > > 2) module_param(disable) for modern users who want module/in-built
> > > symmetry (ie. boot cmdline "usbcore.disable", and "modprobe usbcore
> > > disable")
> >
> > Is there a real reason why we need to change this at all?

You're the only __module_param_call user outside moduleparam.h, and so an 
unrelated patch broke USB. :(

> As far as I know, in Fedora "nousb" is never used as a module parameter.
> It came about because interrupt tables are sometimes bad and once
> a request_irq() is done in an HCD, there's an interrupt storm. So,
> the "nousb" is mostly used in the SysLinux's command line, rarely
> in the real command line, and never in /etc/modprobe.conf.
> I'm adding Jeremy to cc: for confirmation.
>
> I think it would be good to try and drop "nousb" option in Fedora 11.
> The conflict with "nousbstorage" would resolve itself too if we do.

My original patch simply turned it into a core_param (ie. not valid as a 
module parameter).  If this had existed in 2005, it would have been the right 
answer.

If there's any chance of it actually breaking, let's leave it as a module 
parameter too (which is what the patch I sent does).

Thanks,
Rusty.
