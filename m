Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYEZKI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYEZKI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 06:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbYEZKIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 06:08:16 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:42360 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbYEZKIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 06:08:16 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] hiddev: Switch to unlocked_ioctl
Date: Mon, 26 May 2008 12:07:08 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-usb@vger.kernel.org
References: <20080522222217.3a785487@core> <Pine.LNX.4.64.0805261053090.18218@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0805261053090.18218@twin.jikos.cz>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805261207.09175.oliver@neukum.org>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 26 Mai 2008 10:55:09 schrieb Jiri Kosina:
> On Thu, 22 May 2008, Alan Cox wrote:
> 
> > Push down the BKL. In some cases compat_ioctl already doesn't take the
> > BKL so we don't either. 
> 
> Thanks.
> 
> > @@ -555,7 +559,10 @@ static int hiddev_ioctl(struct inode *inode, struct file *file, unsigned int cmd
> >       struct usbhid_device *usbhid = hid->driver_data;
> >       void __user *user_arg = (void __user *)arg;
> >       int i;
> > +     
> > +     /* Called without BKL by compat methods so no BKL taken */
> >  
> > +     /* FIXME: Who or what stop this racing with a disconnect ?? */
> >       if (!hiddev->exist)
> >               return -EIO;
> 
> Oliver (added to CC) -- I vaguely remember you already fixing this race, 
> but I don't seem to be able to find the patch anywhere. Do I just remember 
> incorrectly?

I fixed a race between disconnect and open. Ioctl was not involved.

	Regards
		Oliver
