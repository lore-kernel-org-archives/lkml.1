Return-Path: <linux-kernel-owner+w=401wt.eu-S1763881AbXJZSUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763881AbXJZSUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759027AbXJZST6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:19:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:8649 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758800AbXJZSTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:19:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=qhmSZ/cwvJH935CY6grP3TK6m50QcM/D3mY7T7gRP7Ye45vYUZRVCMOh58bnBG3OVc1vaggx0tQOpAKkUrOU7ayIEraVj2bsU6wt6w+Y6gn0snfpg6I8plrYg4K5upTX+eZdWc32bfz0fiRzbrJRk7qjVF+rmKLtNXC4HxSYmqI=
To: rt2400-devel@lists.sourceforge.net, kernel-stuff@comcast.net
Subject: Re: [Rt2400-devel] [PATCH] rt2500usb - Don't claim 050d:705{0/a}
Date: Fri, 26 Oct 2007 20:39:16 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <alpine.DEB.0.99.0710241909250.18618@parag-desktop> <200710252315.49427.IvDoorn@gmail.com> <alpine.DEB.0.99.0710251837040.9840@parag-desktop>
In-Reply-To: <alpine.DEB.0.99.0710251837040.9840@parag-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710262039.17027.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2007, Parag Warudkar wrote:
> 
> Hi Ivo
> 
> On Thu, 25 Oct 2007, Ivo van Doorn wrote:
> 
> > I awknowledge the problem, but the solution cannot be found in the USB ID's
> > listed in the driver. The bug is the manufacturer who changed chipset while
> > keeping the USB ID the same.
> > There are 2 possible ways around this: hacking the module loader so
> > it continues searching for a different driver when the first driver indicates
> > that it cannot control the device.
> > Or the easiest way, just blacklist rt2500usb if you are sure you need the rt73 driver.
> 
> Thanks for the heads up - I think you have a good idea - there should be 
> an interface between the loader and module to specify conditions like this.
> 
> I will see if I can generate interest in that idea and hack up something 
> along the lines of your suggestion.

Well it could be something quite simple, in the module loader it is looping
through all modules to look for a device with the correct USB/PCI ID.
Currently, after the first occurence it loads the module and doesn't continue,
it should perhaps be relatively easy that it checks if the driver returned -ENODEV
and continues looping to search for another driver.

Ivo
