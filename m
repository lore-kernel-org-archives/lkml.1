Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbZAGPtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbZAGPtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbZAGPtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:49:32 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:48477 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbZAGPtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:49:32 -0500
Date: Wed, 7 Jan 2009 16:49:23 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Ed Swierk" <eswierk@aristanetworks.com>
Cc: linux-i2c@vger.kernel.org, "David Brownell" <david-b@pacbell.net>,
       "Alessandro Zummo" <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "BARRE Sebastien" <sbarre@sdelcc.com>
Subject: Re: [PATCH] rtc-ds1307: True SMBus compatibility
Message-ID: <20090107164923.417aaeac@hyperion.delvare>
In-Reply-To: <9ae48b020901070743x1a5eaf72k5314cd969dc580ef@mail.gmail.com>
References: <1231177261.13443.20.camel@localhost.localdomain>
	<20090107142426.4be04d4d@hyperion.delvare>
	<9ae48b020901070722l77bebc6boc8fa2fd0bcc8da28@mail.gmail.com>
	<20090107162709.755982c0@hyperion.delvare>
	<9ae48b020901070743x1a5eaf72k5314cd969dc580ef@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009 07:43:18 -0800, Ed Swierk wrote:
> On Wed, Jan 7, 2009 at 7:27 AM, Jean Delvare <khali@linux-fr.org> wrote:
> > Did you try 0x4a (as i2c-amd8111 is using)?
> 
> Yes, it returns an error, as do all the other unsupported commands.

Oh well.

> > So, you have the datasheet... Is this something you would be allowed to
> > share with me?
> 
> Unfortunately not; we acquired it under an NDA.

I expected that :(

By any chance, the datasheet doesn't explain why SMBus block
transactions of size 32 lock the chip, nor how to work around it?

> >> I could change the ds1307 driver to check whether the controller
> >> supports i2c block commands and fall back to emulation only if they
> >> are not available. Would that address your concerns?
> >
> > Yes, that would. Same thing the eeprom or lm93 drivers are doing, to
> > only name a few of them. Should be fairly easy.
> 
> OK, will do.

OK. BTW, designing a system with an SMBus master which is so clearly
inappropriate for the I2C chips that are connected to it wasn't exactly
smart to start with. Whoever did this should be told to think twice
about it next time.

-- 
Jean Delvare
