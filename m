Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbYHTGqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbYHTGqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 02:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYHTGpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 02:45:36 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:35849 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbYHTGpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 02:45:25 -0400
Date: Wed, 20 Aug 2008 08:45:22 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sdhci: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter - disabling IRQ
Message-ID: <20080820064522.GA2501@hardeman.nu>
Mail-Followup-To: Pierre Ossman <drzeus-list@drzeus.cx>,
	linux-kernel@vger.kernel.org
References: <20080624181656.GB14243@hardeman.nu> <20080710083457.7887d363@mjolnir.drzeus.cx> <20080711164706.GA8943@hardeman.nu> <20080719015531.6c8a1981@mjolnir.drzeus.cx> <20080802224725.GA6574@hardeman.nu> <20080805112234.759819fe@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080805112234.759819fe@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 11:22:34AM +0200, Pierre Ossman wrote:
>On Sun, 3 Aug 2008 00:47:25 +0200
>David Härdeman <david@hardeman.nu> wrote:
>
>> On Sat, Jul 19, 2008 at 01:55:31AM +0200, Pierre Ossman wrote:
>> >
>> >I see that you have an iwl4965. I got this precise problem when I
>> >toggled the rfkill switch on my laptop. It is fixed in 2.6.26 though.
>> >Could you try upgrading the kernel and see if it's the same bug?
>> 
>> Unfortunately the problem is still present with 2.6.26 (Debian package 
>> linux-image-2.6.26-1-amd64):
>> 
>
>Weird. What kind of efforts have you done in determining the source of
>this interrupt? As I mentioned, I find it hard to believe that the card
>reader is doing this as it is completely passive until you insert a
>card.

Sorry for the delay, vacation times :)

Anyways, it seems that you were right, the interrupt problems doesn't 
seem to stem from the card reader...

>Have you tried booting in a single user mode? Or with a minimal set of
>modules loaded?

I've tried a lot of things, I even bought two microSDHC cards to 
experiment with and I've booted into a limited initramfs with no modules 
loaded and then done the same thing with only the sdhci module loaded.

In the end, it turns out that if the iwl4965 is disabled (e.g. via the 
rfkill button) and stays disabled, no error message is generated (I 
waited for > 30 minutes). If I later enable it and connect to my 
wireless AP, I get the error message approx 10 minutes after I've 
connected to the AP.

Does this mean I should contact the iwl4965 maintainers?

-- 
David Härdeman
