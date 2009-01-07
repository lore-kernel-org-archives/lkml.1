Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbZAGP1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbZAGP1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZAGP1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:27:33 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:35775 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbZAGP1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:27:32 -0500
Date: Wed, 7 Jan 2009 16:27:09 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Ed Swierk" <eswierk@aristanetworks.com>
Cc: linux-i2c@vger.kernel.org, "David Brownell" <david-b@pacbell.net>,
       "Alessandro Zummo" <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "BARRE Sebastien" <sbarre@sdelcc.com>
Subject: Re: [PATCH] rtc-ds1307: True SMBus compatibility
Message-ID: <20090107162709.755982c0@hyperion.delvare>
In-Reply-To: <9ae48b020901070722l77bebc6boc8fa2fd0bcc8da28@mail.gmail.com>
References: <1231177261.13443.20.camel@localhost.localdomain>
	<20090107142426.4be04d4d@hyperion.delvare>
	<9ae48b020901070722l77bebc6boc8fa2fd0bcc8da28@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ed,

On Wed, 7 Jan 2009 07:22:12 -0800, Ed Swierk wrote:
> On Wed, Jan 7, 2009 at 5:24 AM, Jean Delvare <khali@linux-fr.org> wrote:
> > Are you certain the nForce2 controllers can't do it? The i2c-nforce2
> > driver doesn't implement it, but this doesn't mean the hardware can't
> > do it. I don't have any datasheet for these chips, but I know their
> > SMBus implementation is very similar to those of the AMD 8111, and
> > i2c-amd8111 has support for I2C block reads and writes. I think it
> > would be worth giving it a try, by copying the i2c-amd8111
> > implementation into the i2c-nforce2 driver and seeing if it happens to
> > just work. If it works, that would be more elegant than your proposed
> > hack to the rtc-ds1307 driver.
> 
> I checked the datasheet and also tried every possible SMBus command
> value to try to discover any supported commands that the i2c-nforce2
> driver happens not to use, to no avail. The nVidia SMBus is pure
> SMBus.

Did you try 0x4a (as i2c-amd8111 is using)?

So, you have the datasheet... Is this something you would be allowed to
share with me?

> I could change the ds1307 driver to check whether the controller
> supports i2c block commands and fall back to emulation only if they
> are not available. Would that address your concerns?

Yes, that would. Same thing the eeprom or lm93 drivers are doing, to
only name a few of them. Should be fairly easy.

-- 
Jean Delvare
