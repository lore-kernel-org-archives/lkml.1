Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758AbYJ1BVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbYJ1BVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 21:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbYJ1BVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 21:21:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57112 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbYJ1BVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 21:21:04 -0400
Message-ID: <49066840.2070408@cn.fujitsu.com>
Date: Tue, 28 Oct 2008 09:17:52 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip/tracing/markers] new probes manager
References: <48FFE5CB.2050608@cn.fujitsu.com> <20081027155832.GB17250@Krystal> <20081027163046.GA20692@Krystal> <20081027182655.GA11494@elte.hu>
In-Reply-To: <20081027182655.GA11494@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
>>> Do you have performance measurements for this ? On x86 it's a nop,
>>> AFAIK.
>> My statement above is inexact : x86_64 uses lfence for rmb(). But
>> numbers would still be welcome.
> 
> yes, the statement that rmb() is very expensive looks dubious. It is 
> absolutely cheap everywhere.
> 
> 	Ingo
> 
> 
> 

On x86 it's _NOT_ a nop.

i386
#define rmb() alternative("lock; addl $0,0(%%esp)", "lfence", X86_FEATURE_XMM2)

uses the "lock" prefix.

x86_64
#define rmb()	asm volatile("lfence":::"memory")

uses the "lfence"

these two are harm for cache. rmb is exactly a expensive operator.

rmb() is indeed cheaper than any other atomic-operator(atomic, spin_lock .. etc)
everywhere. but In a fast path, avoiding rmb() is worthy.


		Thanx, Lai

