Return-Path: <linux-kernel-owner+w=401wt.eu-S1760646AbYAKLTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646AbYAKLTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 06:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbYAKLTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 06:19:08 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:51040 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757552AbYAKLTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 06:19:07 -0500
Date: Fri, 11 Jan 2008 12:18:55 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: "Bryan Wu" <cooloney.lkml@gmail.com>
Cc: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Cai, Cliff" <Cliff.Cai@analog.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] split MMC_CAP_4_BIT_DATA
Message-ID: <20080111121855.4dba2a97@poseidon.drzeus.cx>
In-Reply-To: <386072610801110222r28e66cb7i6cadb41bf565b3b4@mail.gmail.com>
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
	<386072610801110222r28e66cb7i6cadb41bf565b3b4@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 18:22:14 +0800
"Bryan Wu" <cooloney.lkml@gmail.com> wrote:

> 
> I guess it is for MMC/SD card insert detection. Is it related with the
> 4-bit MMC and 4-bit SD?
> Actually, there are some issues about the card insert detection on
> BF54x SDH. Following is some comments of our bfin-sdh driver which is
> in the development.
> 

Right. As you've noticed, that pin is not a reliable way of detecting cards. It works badly, if all, for MMC cards. And some SD cards also lack the necessary pull-up.

But for the matter at hand, some cards might rely on the pull-up being there, so you'll get bit-errors without it. I don't have time to double check the specs right now, but it might explain why you're seeing problems with MMC and not SD.

Btw, the MMC core sends you ios information on how you should fiddle with that bit. It was needed on a Winbond controller (the wbsd driver) as some models relied on it for card detection.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
