Return-Path: <linux-kernel-owner+w=401wt.eu-S1760520AbYAKKWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520AbYAKKWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 05:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757867AbYAKKWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 05:22:17 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:10679 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692AbYAKKWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 05:22:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Th5mPRG34JdncYIdBJVQ+IEN+lZEosQj58KoqpVWtc9OqWoqjV2Cj9KPY1noDH3OpCLhvXqQHteDN2dYNF0FS46tLa025iV/XK80Fk8VlSXktae+YsZbS6E4rHX1HtWwbBX/b4hlDSJT/WWNKVjHXnMBTRYvlcP1LFbNMySh374=
Message-ID: <386072610801110222r28e66cb7i6cadb41bf565b3b4@mail.gmail.com>
Date: Fri, 11 Jan 2008 18:22:14 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Cc: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Cai, Cliff" <Cliff.Cai@analog.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080111110505.615ae436@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <386072610801081832w2befcbafwe9215067f022ed5d@mail.gmail.com>
	 <20080110095428.3b93fd18@poseidon.drzeus.cx>
	 <386072610801100122n52339488ke2b8724c390be765@mail.gmail.com>
	 <20080110125748.416ad0c5@poseidon.drzeus.cx>
	 <386072610801102217u1739d7d7v497e73a38aa876c2@mail.gmail.com>
	 <20080111094036.4c683791@poseidon.drzeus.cx>
	 <8bd0f97a0801110108l66ab2bcdjb1323573445473f@mail.gmail.com>
	 <20080111103532.2789b74f@poseidon.drzeus.cx>
	 <8bd0f97a0801110147w1cc741c3yc80ad32cd0e896c9@mail.gmail.com>
	 <20080111110505.615ae436@poseidon.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 11, 2008 6:05 PM, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> On Fri, 11 Jan 2008 04:47:44 -0500
> "Mike Frysinger" <vapier.adi@gmail.com> wrote:
>
> > Cliff should be able to enumerate the cards he has tested and the
> > issues he's run into.  i'll see if i cant get more in depth
> > information from the hardware guys beyond the documentation on the sdh
> > already available in the hardware manual (which i'm guessing has not
> > been enough to appease you).
> >
>
> Great. And you're right in that the spec did not give any indication that MMC shouldn't work.
>

Our tester will reopen a tracker of this issue. When it's fired, you
will be updated with this information.

> I did notice one thing though. The pull-ups and pull-downs seem to be controllable. If I remember correctly, DAT3 needs to have a controller-side pull-up for MMC cards. And the docs said the default was not to provide that (in order to use the internal pull-up that most, but not all, SD cards have for detection). Might be something to look at if you haven't already.
>

I guess it is for MMC/SD card insert detection. Is it related with the
4-bit MMC and 4-bit SD?
Actually, there are some issues about the card insert detection on
BF54x SDH. Following is some comments of our bfin-sdh driver which is
in the development.

---
/* In term of ADSP_BF54x_Blackfin_Processor_Peripheral_Hardware_Reference,
 * the SDH allows software to detect a card when it is inserted into its slot.
 * The SD_DATA3 pin powers up low due to a special pull-down resistor. When an
 * SD Card is inserted in its slot, the resistance increases and a rising edge
 * is detected by the SDH module.
 * But this doesn't work sometimes. When a MMC/SD card is inserted, the voltage
 * doesn't rise on SD_DATA3. In term of The MultiMediaCard System Specification,
 * SD_DATA3 is used as CS pin in SPI mode. The MultiMediaCard wakes up in the
 * MultiMediaCard mode. During the scan procedure, host will send CMD0 to reset
 * MMC card, if CS pin is low, MMC card will enter SPI mode. Of course Secure
 * Digital Host controller is not a SPI controller. So the Card detect function
 * has to be disabled. After card is inserted run "echo 0 > /proc/driver/sdh"
 * to trigger card scanning */
---

Thanks
-Bryan Wu
