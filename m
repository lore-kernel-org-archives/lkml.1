Return-Path: <linux-kernel-owner+w=401wt.eu-S1762298AbYD3Rdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762298AbYD3Rdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758616AbYD3Rdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:33:44 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49628 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758195AbYD3Rdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:33:43 -0400
Date: Wed, 30 Apr 2008 19:33:42 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Soumyadip Das Mahapatra <dip_kernel@yahoo.co.in>
cc: linux-kernel@vger.kernel.org
Subject: Re: Improved Swapping Method In sort.c
In-Reply-To: <988568.21908.qm@web94102.mail.in2.yahoo.com>
Message-ID: <alpine.LNX.1.10.0804301932160.5623@fbirervta.pbzchgretzou.qr>
References: <988568.21908.qm@web94102.mail.in2.yahoo.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-04-30 19:09, Soumyadip Das Mahapatra wrote:

>Hello everybody,
>The swapping method (in function void u32_swap() line no.. 14 to 16) in lib/sort.c can be improved by using the following code
>*(u32 *)b ^= *(u32 *)a ^= *(u32 *)b ^= *(u32 *)a instead of the code given. This code
>is not using third variable thus not consuming another memory. And I dont see any significance in
>using *int size* argument. so the function should be
>static void u32_swap(void *a, void *b)
>{
>    *(u32 *)b ^= *(u32 *)a ^= *(u32 *)b ^= *(u32 *)a;
>}

That proposal looks like buggy.

19:32 yaguchi:/dev/shm > cat ui.c 
#include <stdint.h>
#include <stdio.h>

static void u32_swap(void *a, void *b)
{
        *(uint32_t *)b ^= *(uint32_t *)a 
                        ^= *(uint32_t *)b
                        ^= *(uint32_t *)a;
}

int main(void)
{
        uint32_t x = 5, y = 7;
        printf("%u %u\n", x, y);
        u32_swap(&x, &y);
        printf("%u %u\n", x, y);
}
19:32 yaguchi:/dev/shm > ./a.out 
5 7
7 0

