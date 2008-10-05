Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbYJEByK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbYJEByK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 21:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbYJEBx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 21:53:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59157 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbYJEBx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 21:53:56 -0400
Message-ID: <48E81DED.7050902@zytor.com>
Date: Sat, 04 Oct 2008 18:52:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: mtrr_cleanup: first 1M should be coverred in
 var mtrrs
References: <1223157033-30217-1-git-send-email-yhlu.kernel@gmail.com>	 <1223157033-30217-2-git-send-email-yhlu.kernel@gmail.com>	 <48E80E60.8080106@zytor.com> <86802c440810041849g421ff524pf987f6c872e1d12a@mail.gmail.com>
In-Reply-To: <86802c440810041849g421ff524pf987f6c872e1d12a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>> The first 1 MB is a total don't care for the variable MTRRs -- they don't
>> have to be covered *or* uncovered, since the entire first 1 MB is addressed
>> by fixed MTRRs.
> 
> so it is safe to put it in WB, and can be spare some regs because it
> start from base 0.

Yes, my point was that you can make those whatever you want.  It doesn't 
have to be WB; it can be any value.

>> In practice, it is *likely* that you're going to want to merge it with a WB
>> MTRR, but with various vendors doing all kinds of strange things on
>> EFI-damaged platforms, it may not always be that way.
> 
> EFI will not use fixed-mtrr for first 1M? and not cover first 1M in
> var mtrr with WB? that will run out mtrr regs..

There are some systems which, apparently, don't have RAM there.  Don't 
ask me how or why.

	-hpa
