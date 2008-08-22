Return-Path: <linux-kernel-owner+w=401wt.eu-S1759127AbYHVADh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127AbYHVADh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 20:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757768AbYHVADY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 20:03:24 -0400
Received: from hpsmtp-eml13.kpnxchange.com ([213.75.38.113]:46556 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757742AbYHVADY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 20:03:24 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc3: 'APIC error on CPU1: 00(40)', but only on resume!
Date: Fri, 22 Aug 2008 02:02:52 +0200
User-Agent: KMail/1.9.9
References: <200808202106.41058.elendil@planet.nl> <200808202226.45655.elendil@planet.nl> <20080821113141.GB3796@srcf.ucam.org>
In-Reply-To: <20080821113141.GB3796@srcf.ucam.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808220202.52853.elendil@planet.nl>
X-OriginalArrivalTime: 22 Aug 2008 00:03:22.0228 (UTC) FILETIME=[7DA9CB40:01C903EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008, Matthew Garrett wrote:
> On Wed, Aug 20, 2008 at 10:26:45PM +0200, Frans Pop wrote:
> > The only weirdness I can see (only spotted that just now) is that
> > both cores will always seem to be changing frequency together (using
> > ondemand governor), even when 'top' shows one as idle. On my other
> > Core Duo system (an older desktop) the cores react independently.
>
> The cores can't actually be independently scaled.

That makes sense.

> Some older kernels 
> would give the impression that they could, but the package itself will
> run at the greater of the defined frequencies.

It does not seem to be kernel related, but processor related.
Here are some results from two different systems (desktop and laptop) 
running an _identical_ 2.6.27-rc4 x86_64 kernel.
(The desktop is actually Pentium D, not also Core Duo.)

Desktop
=======
processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 4
model name      :               Intel(R) Pentium(R) D CPU 3.20GHz
stepping        : 7
cpu MHz         : 2800.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2

Samples from /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq:
2800000 2800000
2800000 2800000
2800000 3200000		# Start single busy loop, one core idle
3200000 3200000
2800000 3200000
2800000 3200000

Laptop
======
processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     U7700  @ 1.33GHz
stepping        : 13
cpu MHz         : 1333.000
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2

Samples from /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq:
800000 800000
800000 800000
1333000 1333000		# Start single busy loop, one core idle
1333000 1333000
1333000 1333000

So in the first case frequency changes are reported as if the cores are 
independent while in the second case the cores appear linked.

Is a Pentium D really different from a Core Duo in that respect?
