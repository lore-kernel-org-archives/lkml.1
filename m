Return-Path: <linux-kernel-owner+w=401wt.eu-S932109Ab0ANKfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab0ANKfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 05:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314Ab0ANKfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 05:35:43 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:48002 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab0ANKfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 05:35:42 -0500
Message-ID: <4B4EF35D.3040203@pardus.org.tr>
Date: Thu, 14 Jan 2010 12:35:09 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       hpa@zytor.com, mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: Boot hangs after "Freeing initrd memory" with 2.6.31.11
References: <4B4E1633.8010700@pardus.org.tr> <4B4EC0A1.3090503@pardus.org.tr> <4B4ECB1C.6070000@kernel.org>
In-Reply-To: <4B4ECB1C.6070000@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote On 14-01-2010 09:43:
> On 01/13/2010 10:58 PM, Ozan Çağlayan wrote:
>> Ozan Çağlayan wrote On 13-01-2010 20:51:

> 
> can you just deselect CONFIG_X86_CPU_DEBUG in your .config ?

Yes that fixed the issue. I now reenabled it and reverted the following commit which is 1/2 commits
modifying cpu_debug code between 2.6.30..2.6.31:

>From 5095f59bda6793a7b8f0856096d6893fe98e0e51 Mon Sep 17 00:00:00 2001
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Date: Fri, 5 Jun 2009 23:27:17 +0530
Subject: [PATCH] x86: cpu_debug: Remove model information to reduce encoding-decoding

Remove model information, encoding/decoding and reduce bookkeeping.

This, besides removing a lot of code and cleaning up the code, also
enables these features on many more CPUs that were enumerated before.


The other commit is (which I think is just for improving the output):


>From 97a52714658cd959a3cfa35c5b6f489859f0204b Mon Sep 17 00:00:00 2001
From: Andreas Herrmann <andreas.herrmann3@amd.com>
Date: Fri, 8 May 2009 18:23:50 +0200
Subject: [PATCH] x86: display extended apic registers with print_local_APIC and cpu_debug code

Both print_local_APIC (used when apic=debug kernel param is set) and
cpu_debug code missed support for some extended APIC registers that
I'd like to see.

This adds support to show:

 - extended APIC feature register
 - extended APIC control register
 - extended LVT registers

[ Impact: print more debug info ]


