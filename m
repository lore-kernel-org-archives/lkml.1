Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbZCHA4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbZCHA4U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 19:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbZCHA4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 19:56:07 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:57484 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbZCHA4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 19:56:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jv8xozIqAiIvgQcQ4g/0eaaDgN0uOL7h8/ZdMWkmrQISWMYvyHb3m7QYZRt4C/kwY+
         t/1+pfwbyX2ywEpIqMvWSyFlddWBIwmSL8+pHIGCn0mRO0J4eyRSJgKXavzywVYdhOi6
         uVS1X31atjDpVeVtRvaYLh3WKe5NOr5a3xgfI=
Subject: Re: [BUG] Loading both ehci-hcd and uhci-hcd drivers causes my
 printer to fail
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1236457327.6077.83.camel@maxim-laptop>
References: <1236453644.6077.68.camel@maxim-laptop>
	 <20090307195225.GA2585@kroah.com>  <1236457327.6077.83.camel@maxim-laptop>
Content-Type: text/plain
Date: Sun, 08 Mar 2009 02:55:57 +0200
Message-Id: <1236473757.12970.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-07 at 22:22 +0200, Maxim Levitsky wrote:
> On Sat, 2009-03-07 at 11:52 -0800, Greg KH wrote:
> > On Sat, Mar 07, 2009 at 09:20:44PM +0200, Maxim Levitsky wrote:
> > > Hi,
> > > 
> > > Short summary:
> > > 
> > > I have HP1018 printer, and it works well in windows.
> > > When I use in in linux, I often see messages like:
> > > 
> > > usbfs: USBDEVFS_CONTROL failed cmd python rqt 128 rq 6 len 255 ret -110
> > > 
> > > This is using hp backend that talks to printer using usbfs.
> > > I also tried usblp, but it just doesn't say anything in kernel log. I
> > > think it silently ignores similar errors, because the end result is the
> > > same, the printer sometimes works, but sometimes doesn't.
> > > (printer needs firmware to be uploaded to it, and I do upload it).
> > > 
> > > On the other hand, IF I remove _ether_ ehci-hcd or uhci-hcd from kernel,
> > > then everything works fine, I already rebooted the printer many times,
> > > used it to print, upload firmware, and everything just work, but as soon
> > > as I load the second driver it fails in same way again.
> > > 
> > > USB issues with this class of printers are nothing but new, for example
> > > see:
> > > 
> > > http://foo2zjs.rkkda.com/forum/read.php?9,374
> > > https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.15/+bug/54419
> > 
> > What kernel version are you using?
> > 
> > > I compiled without CONFIG_USB_EHCI_ROOT_HUB_TT
> > > and it did help (didn't that much testing, but at least firmware loads
> > > ok, and no error messages)
> > 
> > Can you provide the full kernel log messages from when you plug in your
> > printer?  Are there any other messages saying that you need to be sure
> > to load one driver before the other?
> I am familiar with these messages, maybe instead uhci should depend on
> ehci or something like that?
> 
> Tommorow I try to load them manually in correct order.
> Btw, if I unload both and then load first ehci then uhci, this is ok
> (if they were loaded incorrectly)
> 
> 
> Confirm again that without CONFIG_USB_EHCI_ROOT_HUB_TT both drivers
> work.
> 
> dmesg (from /var/log/kern.log.0) attached
> It shows how I rebooted the printer often.
> It also have this error message about the order.
> 
> But this isn't related.
> I currently blacklisted uhci-hcd, so only ehci-hcd gets loaded.
> Then I loaded the uhci, and got same bug
> (This is why I attached an older dmesg, if you need I reproduce that bug
> again)
> 
> 
> To be clear, usually after these error messages (... -110), printer
> stops working, it is so confused, all attempts to access it hang.
> Only reboot helps.

And of course, forgot, kernel is vanilla 2.6.28
with compat-wireless patches.

Best regards,
	Maxim Levitsky

