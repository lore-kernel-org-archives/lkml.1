Return-Path: <linux-kernel-owner+w=401wt.eu-S1761233AbXKER1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761233AbXKER1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760255AbXKERXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:23:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43298 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759422AbXKERXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:23:03 -0500
Message-ID: <472F516C.6020702@zytor.com>
Date: Mon, 05 Nov 2007 09:22:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bo_Brant=E9n?= <bosse@acc.umu.se>
CC: linux-kernel@vger.kernel.org
Subject: Re: x86_64 ten times slower than i386
References: <Pine.A41.4.64.0711031329490.397338@stalin.acc.umu.se> <20071103162640.GS17536@waste.org> <Pine.A41.4.64.0711032334170.770224@stalin.acc.umu.se> <Pine.A41.4.64.0711051110530.803034@stalin.acc.umu.se>
In-Reply-To: <Pine.A41.4.64.0711051110530.803034@stalin.acc.umu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bo Brantén wrote:
> 
>> On Sat, 3 Nov 2007, Matt Mackall wrote:
>>
>>> This is typically due to a problem with the setup of your MTRRs. Try
> 
> This is the output from cat /proc/mtrr
> 
> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
> reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
> reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
> reg03: base=0xcf800000 (3320MB), size=   8MB: uncachable, count=1
> reg04: base=0xcf700000 (3319MB), size=   1MB: uncachable, count=1

Confusing!  Your maximum would be 3072+256M = 3328M, except that because 
of the uncachable MTRRs (presumably stolen memory for video), the 
maximum is 3319M.

	-hpa
