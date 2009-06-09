Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbZFIRdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbZFIRdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 13:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbZFIRdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 13:33:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:61842 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbZFIRdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 13:33:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 09/27] score: create head files hardirq.h hw_irq.h
Date: Tue, 9 Jun 2009 19:33:08 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
References: <OFE06CA763.2ED1275C-ON482575D0.00237A09-482575D0.0023EB63@sunplusct.com>
In-Reply-To: <OFE06CA763.2ED1275C-ON482575D0.00237A09-482575D0.0023EB63@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906091933.08483.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18WliR3CVEZtNtLUxzBYegkbASBvmS+4h5rcFp
 y3+FS3akHeFNCdB7hNDRKUX1YKGO1+m4YV5Me610qK6tuGiJ5n
 p2HzeBnyPc0xHGO+0l6sQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009, liqin.chen@sunplusct.com wrote:
> --- /dev/null
> +++ b/arch/score/include/asm/hardirq.h
> @@ -0,0 +1,16 @@
> +#ifndef _ASM_SCORE_HARDIRQ_H
> +#define _ASM_SCORE_HARDIRQ_H
> +
> +#include <linux/threads.h>
> +#include <linux/irq.h>
> +
> +typedef struct {
> +       unsigned int __softirq_pending;
> +} ____cacheline_aligned irq_cpustat_t;
> +
> +/* Standard mappings for irq_cpustat_t above */
> +#include <linux/irq_cpustat.h>
> +
> +extern void ack_bad_irq(unsigned int irq);

In this case (ack_bad_irq is extern), you can still use
the generic file by adding

#define ack_bad_irq ack_bad_irq

in front of the #include, in order to override the default
implementation.

	Arnd <><
