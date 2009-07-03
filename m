Return-Path: <linux-kernel-owner+w=401wt.eu-S1757775AbZGCTI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775AbZGCTI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbZGCTIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:08:42 -0400
Received: from claw.goop.org ([74.207.240.146]:46650 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757136AbZGCTIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:08:41 -0400
Message-ID: <4A4E5738.6080407@goop.org>
Date: Fri, 03 Jul 2009 12:08:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: lkml@MoreThan.org
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
References: <200907031314.36243.lkml@morethan.org> <87fxddaafv.fsf@basil.nowhere.org> <200907031338.24778.lkml@morethan.org>
In-Reply-To: <200907031338.24778.lkml@morethan.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/09 11:38, Michael S. Zick wrote:
> I make no claims for it at the moment - too early in the test process.
> Just the general observation that it takes 0.5M to describe 0.5G of ram.
>   
Only if you're using 4k pages.  With large pages, 1 pte can map 2M, so
256 entries can map 512M, so you only need 1/2 a page of pagetable
(assuming PAE; if not a single entry can map 4M).

> Also, 
> the observation that (1<<32) drops the bit off the left end of a 32-bit value.
> You can see the result in the portion of the post you snipped out.  ;)
>   

Those computations aren't done as 32-bit.

$ as << EOF
.data
.byte (1 << 100) >> 100
EOF
$ objdump -D a.out

a.out:     file format elf64-x86-64

Disassembly of section .data:

0000000000000000 <.data>:
   0:    01                       .byte 0x1


    J
