Return-Path: <linux-kernel-owner+w=401wt.eu-S936186AbXFFWHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936186AbXFFWHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbXFFWHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:07:36 -0400
Received: from lucidpixels.com ([75.144.35.66]:33416 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935111AbXFFWHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:07:35 -0400
Date: Wed, 6 Jun 2007 18:07:34 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jesse Barnes <jesse.barnes@intel.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <200706061505.11741.jesse.barnes@intel.com>
Message-ID: <Pine.LNX.4.64.0706061805570.4824@p34.internal.lan>
References: <200706061229.24486.jesse.barnes@intel.com>
 <Pine.LNX.4.64.0706061747180.3697@p34.internal.lan>
 <Pine.LNX.4.64.0706061803040.4671@p34.internal.lan> <200706061505.11741.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Jun 2007, Jesse Barnes wrote:

> On Wednesday, June 6, 2007 3:03 pm Justin Piszcz wrote:
>> Mem:   8039620k total,  7936472k used,   103148k free,      708k
>> buffers Mem:   8039608k total,   969380k used,  7070228k free,
>> 1232k buffers
>>
>> I am curious, why does the patch != the mem=8832M?
>
> I'm not sure... can you post your e820 map from boot and the contents
> of /proc/mtrr?  Maybe my patch is trimming off a few too many pages, or
> maybe 8832M isn't quite right and actually ends up leaving you with a
> few uncached pages.
>
> Jesse
>

I cannot post the E820 memory map, I have no way to capture it, I cannot 
get anything from netconsole and dmesg does not show it either.

BEFORE:
reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
reg03: base=0xcf800000 (3320MB), size=   8MB: uncachable, count=1
reg04: base=0xcf700000 (3319MB), size=   1MB: uncachable, count=1
reg05: base=0x100000000 (4096MB), size=4096MB: write-back, count=1
reg06: base=0x200000000 (8192MB), size= 512MB: write-back, count=1
reg07: base=0x220000000 (8704MB), size= 128MB: write-back, count=1

AFTER:
$ cat /proc/mtrr
reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
reg03: base=0xcf800000 (3320MB), size=   8MB: uncachable, count=1
reg04: base=0xcf700000 (3319MB), size=   1MB: uncachable, count=1
reg05: base=0x100000000 (4096MB), size=4096MB: write-back, count=1
reg06: base=0x200000000 (8192MB), size= 512MB: write-back, count=1
reg07: base=0x220000000 (8704MB), size= 128MB: write-back, count=1

But that still works.

Justin.
