Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965723Ab0BZSwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 13:52:11 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:42648 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965700Ab0BZSwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 13:52:09 -0500
X-Spam-Processed: digidescorp.com, Fri, 26 Feb 2010 12:52:07 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=16730ac33d=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: Buggy variable-length array code...or compiler?
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: "J.A." =?ISO-8859-1?Q?Magall=F3n?= <jamagallon@ono.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100226014623.11d8d79f@werewolf.home>
References: <1267139849.3079.68.camel@iscandar.digidescorp.com>
	 <20100226014623.11d8d79f@werewolf.home>
Content-Type: text/plain; charset="UTF-8"
Organization: Digital Design Corporation
Date: Fri, 26 Feb 2010 12:52:05 -0600
Message-Id: <1267210325.3124.188.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-26 at 01:46 +0100, J.A. Magallón wrote:

> Can you try this in userspace ? I compiled in CentOS gcc 4.1.2 (just the
> same), and the addresses are always the same:
> 
> #include <stdio.h>
> 
> int main()
> {
>     int c = 2;
>     while (1)
>     {
>         int a[c];
>         int b[c];
>         a[0] = b[0];
>         printf("%p %p\n",a,b);
>     }
> }

On the Microblaze:

0x2d711f1c 0x2d711f10
0x2d711f04 0x2d711ef8
0x2d711eec 0x2d711ee0
0x2d711ed4 0x2d711ec8

This happens no matter what optimization setting I compile with.

> 
> Could you post the full contents of the while loop ? 

It's the stock drivers/dma/dmatest.c in 2.6.33.

> Which is the size of dma_addr_t ? 
Microblaze is a 32-bit arch; dma_addr_t is 32 bits.

> Does it match the difference of 16 bytes on each iteration ? 
No. It appears that the data going on the stack each iteration are:

  dma_srcs[0]: iteration n
  total_tests: [n-2]
  X
  dst_off:     [iteration n-1]
  dma_srcs[0]: iteration n-1
  total_tests [n-3]
  X

> cnt's are always 1, isn't it ?
For the memcpy test, yes/

> Can you switch the size to a fixed '1' to see if this hangs again ?
It does not.

Regards,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>



