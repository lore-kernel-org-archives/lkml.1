Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbZELAiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbZELAiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 20:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbZELAh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 20:37:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56169 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbZELAhz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 20:37:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] move PIT_TICK_RATE to linux/timex.h
Date: Tue, 12 May 2009 02:36:35 +0200
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org, x86@kernel.org, rth@twiddle.net,
       ralf@linux-mips.org, tiwai@suse.de, dmitry.torokhov@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
References: <20090511222702.352192505@arndb.de> <200905112255.37215.arnd@arndb.de> <20090511170146.143a1551.akpm@linux-foundation.org>
In-Reply-To: <20090511170146.143a1551.akpm@linux-foundation.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905120236.36242.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19m9a9r2MbE0PGCZTmokNajk35bn4uQaAVoVbk
 HzS6m4mb6twLfrtljYGp/zuV+5CFzp5Vejf0I9EVd1DJrGRmld
 SD0q1RDrGTjXoXZxNxAuA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 May 2009, Andrew Morton wrote:
> So the type got changed in arch/x86/include/asm/timex.h.  Did you check
> whether that changes anything? I did a quick check and didn't see any
> obvious problems..

I did not check if the object file changes, just checked that the
macro is not used in assembly code, which would break.

Note that for Alpha, the actual value changed from 1193182UL to
1193180UL. This is unlikely to make a difference, and probably
can only improve accuracy. There was a discussion on the correct
value of CLOCK_TICK_RATE a few years ago, after which every existing
instance was getting changed to 1193182. According to the specification,
it should be 1193181.818181...

	Arnd <><
