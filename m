Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbXLGAWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbXLGAWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 19:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbXLGAWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 19:22:09 -0500
Received: from gw.goop.org ([64.81.55.164]:52009 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbXLGAWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 19:22:08 -0500
Message-ID: <4758922D.7010006@goop.org>
Date: Thu, 06 Dec 2007 16:22:05 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c
References: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org> <20071201003333.GR29463@stusta.de>
In-Reply-To: <20071201003333.GR29463@stusta.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Thu, Nov 29, 2007 at 04:19:51PM -0800, H. Peter Anvin wrote:
>   
>> When the conversion factor between jiffies and milli- or microseconds
>> is not a single multiply or divide, as for the case of HZ == 300, we
>> currently do a multiply followed by a divide.  The intervening
>> result, however, is subject to overflows, especially since the
>> fraction is not simplified (for HZ == 300, we multiply by 300 and
>> divide by 1000).
>> ...
>>  kernel/Makefile     |    8 +++
>>  kernel/time.c       |   29 +++++++++---
>>  kernel/timeconst.bc |  123 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 152 insertions(+), 8 deletions(-)
>>  create mode 100644 kernel/timeconst.bc
>> ...
>>     
>
> I have read the hep text, but are the advantages of HZ == 300 really 
> visible or was this more theoretical?
>
> In the latter case, we might remove the HZ == 300 choice instead.
>   

300 is useful for video applications, since its a multiple of both 50
and 60Hz.  Tickless may make this less relevent though.

    J
