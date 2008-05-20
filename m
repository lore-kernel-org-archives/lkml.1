Return-Path: <linux-kernel-owner+w=401wt.eu-S933634AbYETPBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634AbYETPBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932819AbYETPBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:01:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45142 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206AbYETPBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:01:18 -0400
Message-ID: <4832E61A.3080009@zytor.com>
Date: Tue, 20 May 2008 07:54:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Harvey Harrison <harvey.harrison@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] asm-generic/int-ll64.h: always provide __{s,u}64
References: <20080519215452.GK17716@cs181133002.pp.htv.fi> <4831F89F.5060106@zytor.com> <1211236048.5915.94.camel@brick> <20080519223232.GB17716@cs181133002.pp.htv.fi> <48321299.80303@zytor.com> <20080520001345.GG17716@cs181133002.pp.htv.fi> <4832189B.8000602@zytor.com> <20080520003315.GH17716@cs181133002.pp.htv.fi> <4832266D.5010203@zytor.com> <20080520090949.GI17716@cs181133002.pp.htv.fi>
In-Reply-To: <20080520090949.GI17716@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> 
> $ cat test.c
> #include <stdio.h>
> 
> int main()
> {
> #ifdef __i486__
>   printf("foobarbaz\n");
> #endif
> 
>   return 0;
> }

*Groan* you're right.  Blitering idiots... they only present __i386__ 
and whatever *exact* CPU you have -march= for, which of course is a 
*CHANGING SET* (just __i486__, __i586__ and __i686__ isn't enough... 
they seem to also have __core2__, __k8__ and $DEITY knows what else.)

The only sensible way to handle that would be to centralize that 
knowledge in a header file.

	-hpa
