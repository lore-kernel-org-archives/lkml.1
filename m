Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbZHTRDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbZHTRDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 13:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbZHTRDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 13:03:15 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48988 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbZHTRDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 13:03:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hlKPHhTdeFDvmqWxcp7l4SBB806YBdOCe/AVBAJtdb1+EVsVETuVkf9r6xiY5qsJgq
         uNXJrm/62Z7/jKJLnBdO7rzIR59H+oaL1xXzPtRcETaSRDvAB2DZ7m/418TFYiqF0/QV
         5fwWqKArIyPp1gyXakkMLzstMwyO9PQCrdsaw=
MIME-Version: 1.0
Reply-To: q-funk@iki.fi
In-Reply-To: <20090820124002.58d3d25b@mycelium.queued.net>
References: <20090818175314.16c81ca4@mycelium.queued.net>
	 <s5hd46qo6j3.wl%tiwai@suse.de>
	 <20090820124002.58d3d25b@mycelium.queued.net>
Date: Thu, 20 Aug 2009 20:03:14 +0300
X-Google-Sender-Auth: b845e221915664d7
Message-ID: <11fae7c70908201003x3f7bf8aga74aa7db4dbba3d2@mail.gmail.com>
Subject: Re: [PATCH 1/3] cs5535-gpio: add AMD CS5535/CS5536 GPIO driver 
	support
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <q-funk@iki.fi>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: Takashi Iwai <tiwai@suse.de>, deepak@laptop.org, Tobias_Mueller@twam.info,
       linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       akpm@linux-foundation.org, cjb@laptop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On Thu, 20 Aug 2009 17:21:20 +0200 Takashi Iwai <tiwai@suse.de> wrote:
> BTW CONFIG_GPIO_CS5536 and CONFIG_CS5536_GPIO are so confusing... :)

That's because too many people who write drivers lack a bird's eye
view on the whole Geode platform's history and end up inventing driver
names that only further add to the confusion.  Ages ago, on the Geode
list (I cannot remember if was the AMD PCS maintained list or the
X.org Geode list), we came to the following nomenclature:

gx1:  driver that only affects the first-generation GX from Cyrix or
NSC and the NSC SC system on chip's CPU+FPU components.
gx:  driver that only affects the NSC/AMD Media GX (a.k.a. GX2 Red
Cloud) CPU+FPU components.
lx:  driver that only affect the AMD LX CPU+FPU components.
sc1100:  driver that only affect the sc1100 system on chip's peripheral drivers.
scx200:  driver that affects the sc1200, sc2200 and sc3200 systems on
chip's peripheral drivers.
cs5510:  driver that only affect the cs5510 companion chip.
cs5520:  driver that only affect the cs5520 companion chip.
cs5530:  driver that affects the cs5530 (or cs5530a) companion chip alone.
cs5535:  driver that affects the cs5535 and cs5536 companion chips.
cs5536:  driver that affects the cs5536 specifically (same as cs5535,
plus USB 2.0 support and a different PATA implementation).
cs553x:  driver that affects the WHOLE cs553x series. Should not be
used since the cs5530 and cs553[5|6] are different beasts.
geode:  driver that affects the whole Geode series, such as the SM bus.

Sadly, some drivers don't respect this nomenclature, the most common
mistake being to use cs553x for a driver that only works on cs5535 and
cs5536. Another mistake was the naming of the ALSA driver, which came
as snd-cs5535audio instead of just snd-cs5535.

Martin-Éric
