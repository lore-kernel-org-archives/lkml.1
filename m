Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbYFKHJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbYFKHJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 03:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbYFKHJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 03:09:09 -0400
Received: from s131.mittwaldmedien.de ([62.216.178.31]:5738 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbYFKHJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 03:09:08 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Adrian Bunk <adrian.bunk@movial.fi>
Subject: Re: [PATCH] console - Add configurable support for console charset translation
Date: Wed, 11 Jun 2008 09:08:55 +0200
User-Agent: KMail/1.9.7
Cc: Tim Bird <tim.bird@am.sony.com>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
References: <48447615.5050806@am.sony.com> <20080604103353.GC27335@cs181133002.pp.htv.fi>
In-Reply-To: <20080604103353.GC27335@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806110908.55093.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does the linux-tiny approach of adding a kconfig variable for
> each 5kB of code actually make sense? I'm asking since an
> exploding amount of kconfig variables and their
> interdependencies have a not so small maintainance impact in
> the long term.

I don't want to answer for the general case, but I can answer for 
my specific case.

My device has Intel Strataflash, which have 256 kB size of 
erase-sectors. I reserved one sector for u-boot (which is 
plenty) and 4 for linux --- which uses to be plenty in the 
2.4.21 days.

It is no longer plenty, some years ago I switched one of the 
targets to 2.6.15. The 4 sectors still were ok. Some months ago 
I switched to 2.6.24/2.6.25 and now space is VERY scarce. Just 
yesterday, when I trashed unionfs because of some misbehavior I 
couldn't fix by myself and went with aufs. Now my kernel 
suddenly became 14 kB too big for my device.

Now, tiny-linux patches are at 2.6.23, but I could still adapt a 
bunch of them to 2.6.25 and with that and some changed configs 
my headroom is now again 26460 bytes. Unfortunately, my custom 
boot logo had to go :-/
