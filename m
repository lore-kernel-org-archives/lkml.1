Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbZHNWne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbZHNWne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 18:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757189AbZHNWne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 18:43:34 -0400
Received: from kroah.org ([198.145.64.141]:46487 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757223AbZHNWnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 18:43:33 -0400
Date: Fri, 14 Aug 2009 15:18:30 -0700
From: Greg KH <greg@kroah.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Samsung backlight driver
Message-ID: <20090814221830.GA13114@kroah.com>
References: <20090814194815.GA31474@kroah.com>
 <20090814222533.26D94526EC9@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090814222533.26D94526EC9@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 02:54:40PM -0700, Dmitry Torokhov wrote:
> Hi Greg,
> 
> On Fri, Aug 14, 2009 at 12:48:15PM -0700, Greg KH wrote:
> > +
> > +static int update_status(struct backlight_device *bd)
> > +{
> > +	if (!pci_device)
> > +		return -ENODEV;
> > +	if (!backlight_device)
> 
> How is this possible?

It's probably not, I was just being paranoid.  You're right, I can drop
all of these checks and rework the find logic a bit.

> > +		return -ENODEV;
> > +
> > +	current_brightness = bd->props.brightness;
> > +	set_brightness();
> > +	return 0;
> > +}
> > +
> > +static struct backlight_ops backlight_ops = {
> > +	.get_brightness	= get_brightness,
> > +	.update_status	= update_status,
> > +};
> > +
> > +static int find_video_card(void)
> > +{
> > +	struct pci_dev *dev = NULL;
> > +
> > +	while ((dev = pci_get_device(0x8086, 0x27ae, dev)) != NULL) {
> > +		/* Found one, so let's save it off */
> > +		if (!pci_device)
> > +			pci_device = pci_dev_get(dev);
> 
> If you need to iterate all matching devices you need to save them all or
> release references to "extras" right here... Or, better yet, just break
> after you find the first one.

It's a trivially small loop, this way I get the "hm, do I need to drop
the reference or not" logic correct :)

> > +	}
> > +
> > +	if (!pci_device)
> > +		return 0;
> 
> Why not -ENODEV? What is the point of having this driver loaded if the
> device is not available? Then you could drop all silly "if (!pci_device)"
> checks.

Ah, you are right, thanks, I'll go fix that.

thanks for the review, I appreciate it.

greg k-h
