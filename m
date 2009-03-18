Return-Path: <linux-kernel-owner+w=401wt.eu-S1758371AbZCROOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371AbZCROOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 10:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758129AbZCROOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 10:14:32 -0400
Received: from ns1.suse.de ([195.135.220.2]:45855 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144AbZCROOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 10:14:31 -0400
Date: Wed, 18 Mar 2009 15:14:29 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Bill Gribble <grib@billgribble.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: usbhid:  Changes since 2.6.28 in quirk handling?
In-Reply-To: <1236947942.9606.26.camel@localhost>
Message-ID: <alpine.LNX.2.00.0903181511010.12145@wotan.suse.de>
References: <1236947942.9606.26.camel@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Mar 2009, Bill Gribble wrote:

> Hi, I have been maintaining a patch for a quirky USB device built-in to 
> a UMPC, the Raon Digital Everun.  Without the patch, the builtin 
> keyboard, mouse, and touchscreen are useless.  I have never submitted it 
> for inclusion in the kernel because there are less than 5 people who 
> have ever even attempted to install Linux on this device, and it's 
> discontinued.  However, *I* use the thing daily, and its wifi device 
> (libertas) has continued to get better support in the recent kernels so 
> I port the patch forward.

Hi Bill,

we have drivers (and even whole architectures) supported by the kernel, 
which have less than 5 users in the world, that's not a big deal.

It makes 5 people happy, and saves you the pain from having to keep the 
out-of-tree code working with the Linux kernel API changing all the time.

> I noticed that the structure of the quirk handling code has changed 
> somewhat; I left my patch using the "old" way of adding an entry to 
> hid_blacklist in hid-quirks.c.  Is there a document or email trail that 
> describes the new way of structuring this quirk code?  Any pitfalls to 
> look out for?

Looking at your patch, the only thing you need is sending a special URB to 
the device in order to make it operational, right?

Please look at hid-sony driver, which does exactly that for some of the 
PS3 devices.

You then only need to add your device to hid_blacklist[], so that generic 
driver doesn't get bound to it and it'd be driven by your special driver.

-- 
Jiri Kosina
SUSE Labs
