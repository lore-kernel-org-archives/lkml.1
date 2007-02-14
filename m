Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbXBNTTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbXBNTTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932459AbXBNTTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:19:43 -0500
Received: from mail.gurulabs.com ([67.137.148.7]:53560 "EHLO mail.gurulabs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436AbXBNTTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:19:42 -0500
Subject: Re: Linus' laptop and Num lock status
From: Dax Kelson <dax@gurulabs.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>
In-Reply-To: <Pine.LNX.4.64.0702141104210.3604@woody.linux-foundation.org>
References: <1171479361.3706.48.camel@mentorng.gurulabs.com>
	 <Pine.LNX.4.64.0702141104210.3604@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 14 Feb 2007 12:19:40 -0700
Message-Id: <1171480780.3706.56.camel@mentorng.gurulabs.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-14 at 11:12 -0800, Linus Torvalds wrote:
> 
> On Wed, 14 Feb 2007, Dax Kelson wrote:
> > 
> > Are there any technical or political reasons why kernel can't change
> > from "force off" to "Follow BIOS"?
> 
> How would you query it? I'm not even 100% sure that you can on all 
> keyboards. We never query the leds, we always set them. I think. I don't 
> know of any AT kbd command to read the led state out of the keyboard.
> 
> 		Linus

The GPL'd "hwinfo" command shipped with SUSE queries the BIOS setting by
reading a single byte from /dev/mem.

In src/hd/bios.c around line 262 it has:

  if(hd_data->bios_ram.data) {
    bios_ram = hd_data->bios_ram.data;

[snip]

    bt->led.scroll_lock = bios_ram[0x97] & 1;
    bt->led.num_lock = (bios_ram[0x97] >> 1) & 1;
    bt->led.caps_lock = (bios_ram[0x97] >> 2) & 1;
    bt->led.ok = 1;


Cut-n-paste commands to get to the source:

cd /tmp
wget http://ftp.opensuse.org/pub/opensuse/distribution/SL-OSS-factory/inst-source/suse/src/hwinfo-13.21-3.src.rpm
rpm2cpio < hwinfo-13.21-3.src.rpm | cpio -id
tar jxf hwinfo-13.21.tar.bz2
cd hwinfo-13.21/src/hd

Dax Kelson

