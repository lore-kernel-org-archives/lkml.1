Return-Path: <linux-kernel-owner+w=401wt.eu-S1762424AbXFCM23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762424AbXFCM23 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 08:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759235AbXFCM2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 08:28:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48382 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759048AbXFCM2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 08:28:00 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: Kernel 2.6.22-rc3 breaks USB: Unable to get HID descriptor (error sending control message: Operation not permitted)
Date: Sun, 3 Jun 2007 12:54:51 +0200
User-Agent: KMail/1.9.1
Cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0706021841520.3376@p34.internal.lan> <Pine.LNX.4.64.0706031146470.29896@twin.jikos.cz> <Pine.LNX.4.64.0706030634400.3574@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706030634400.3574@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706031254.52434.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 3. Juni 2007 12:36 schrieb Justin Piszcz:
> 
> On Sun, 3 Jun 2007, Jiri Kosina wrote:
> 
> > On Sat, 2 Jun 2007, Justin Piszcz wrote:

> >> failed to claim USB device, trying 2 more time(s)...
> >> detaching kernel driver from USB device...
> >
> > Could you please provide strace outputs (or put it on the web somewhere if
> > it's too big) for the failing and succeeding claiming of the device?

static int usbdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
{
	struct dev_state *ps = file->private_data;
	struct usb_device *dev = ps->dev;
	void __user *p = (void __user *)arg;
	int ret = -ENOTTY;

	if (!(file->f_mode & FMODE_WRITE))
		return -EPERM;

That check fails as your application falls back to opening read only in
case of insufficient permissions. Did you change some udev rules?

	Regards
		Oliver
