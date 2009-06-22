Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbZFVJ23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbZFVJ23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 05:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbZFVJ2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 05:28:20 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:37498 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbZFVJ2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 05:28:20 -0400
Message-ID: <4A3F6AD5.1030703@linux.vnet.ibm.com>
Date: Mon, 22 Jun 2009 13:28:21 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: gcov: enable GCOV_PROFILE_ALL for x86_64
References: <200906182200.n5IM0jFq007278@hera.kernel.org> <20090620101424.GA21928@elte.hu>
In-Reply-To: <20090620101424.GA21928@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> 
>> Gitweb:     http://git.kernel.org/linus/7bf99fb673f18408be1ebc958321ef4c3f6da9e2
>> Commit:     7bf99fb673f18408be1ebc958321ef4c3f6da9e2
>> Parent:     2521f2c228ad750701ba4702484e31d876dbc386
>> Author:     Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
>> AuthorDate: Wed Jun 17 16:28:09 2009 -0700
>> Committer:  Linus Torvalds <torvalds@linux-foundation.org>
>> CommitDate: Thu Jun 18 13:03:58 2009 -0700
>> 
>>     gcov: enable GCOV_PROFILE_ALL for x86_64
>>     
>>     Enable gcov profiling of the entire kernel on x86_64. Required changes
>>     include disabling profiling for:
>>     
>>     * arch/kernel/acpi/realmode and arch/kernel/boot/compressed:
>>       not linked to main kernel
>>     * arch/vdso, arch/kernel/vsyscall_64 and arch/kernel/hpet:
>>       profiling causes segfaults during boot (incompatible context)
> 
> This feature crashes on bootup:

I can recreate the crash using your config. It looks like another object file in arch/x86 is incompatible with gcov profiling (most likely due to special stack usage) and needs to be excluded from profiling. I'm working on identifying this file but it will take a bit more time.
