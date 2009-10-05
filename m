Return-Path: <linux-kernel-owner+w=401wt.eu-S1751917AbZJEFDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbZJEFDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 01:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbZJEFDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 01:03:53 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:50046 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbZJEFDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 01:03:53 -0400
MIME-Version: 1.0
In-Reply-To: <f488382f0910041924p5e9eae48qa19afc81c43fca3d@mail.gmail.com>
References: <f488382f0910031754p7e29f6f9mc78dc9bc9b0c63b4@mail.gmail.com>
	 <f488382f0910041924p5e9eae48qa19afc81c43fca3d@mail.gmail.com>
Date: Sun, 4 Oct 2009 22:03:16 -0700
Message-ID: <f488382f0910042203x38365b9amd557803872cc1435@mail.gmail.com>
Subject: Re: cpufreq scaling strangely, system feels warm
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 4, 2009 at 7:24 PM, Steven Noonan <steven@uplinklabs.net> wrote:
> On Sat, Oct 3, 2009 at 5:54 PM, Steven Noonan <steven@uplinklabs.net> wrote:
>> I have a system that's behaving as though it's under a moderate load,
>> but nothing's happening and the load average is zero. If I change my
>> cpufreq governor to 'conservative' or 'ondemand', the CPU immediately
>> scales up to the maximum clock frequency (as though something was
>> demanding that much power). The system is also very warm, which is
>> abnormal even when the machine is always clocked at its maximum
>> frequency.
>>
>> Top shows that there are no processes which are hogging the CPU, and
>> /proc/interrupts doesn't reveal anything interesting (i.e. an
>> interrupt storm). The only way to get my system to stay cool is to
>> change the cpufreq governor to 'powersave' or 'userspace' (and then
>> clock it at the lowest, manually).
>>
>
> Scratch that. It's probably an interrupt storm. 'perf top' shows
> 19,000 IRQs per second. And I recall that 500-1500 per second was
> normal for this machine. Now the problem is figuring out where the
> interrupt storm is coming from...
>

Went through my kernel config and found some odd settings, fixed them
and recompiled. Now 'ondemand' works as it should, but 'conservative'
always clocks up to the maximum frequency. I can't figure out why.

Is there a way to get cpufreq to print out some explanations in dmesg
as to why 'conservative' is doing what it does?

- Steven
