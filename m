Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbZGOOD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbZGOOD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 10:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbZGOODZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 10:03:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:56792 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711AbZGOODZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 10:03:25 -0400
Subject: Carefully chosen CYC2NS_SCALE_FACTOR ??
From: Petr Tesarik <ptesarik@suse.cz>
To: Andi Kleen <andi@firstfloor.org>, John Stultz <johnstul@us.ibm.com>,
       george@mvista.com
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: SUSE LINUX
Date: Wed, 15 Jul 2009 16:03:23 +0200
Message-Id: <1247666603.11358.62.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm having trouble understanding the rationale behind the choice for
CYC2NS_SCALE_FACTOR in arch/x86/include/asm/timer.h:

#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */

Why on Earth is this 10?

AFAICS this constant is the position of the decimal point in the
fixed-point cycle-to-nanoseconds computations. It is computed as
follows:

                *scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;

Now, NSEC_PER_MSEC is 10^6, the size of cyc2ns is 32 bits and cpu_khz,
being an integer, cannot be less than 1. So, if I want maximum accuracy,
I should choose the maximium CYC2NS_SCALE_FACTOR such that:

10^6 * 2^CYC2NS_SCALE_FACTOR < 2^32

Which transforms to:

CYC2NS_SCALE_FACTOR = floor(log2(2^32/NSEC_PER_MSEC)) = 12

Did I miss an obvious reason for not using the scale factor of 12?

TIA,
Petr Tesarik
SUSE Linux


