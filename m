Return-Path: <linux-kernel-owner+w=401wt.eu-S933262AbZAOVzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbZAOVzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932663AbZAOVzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:55:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:55964 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932694AbZAOVzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:55:10 -0500
Message-ID: <496FB09A.8020808@kernel.org>
Date: Fri, 16 Jan 2009 06:54:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: roel kluin <roel.kluin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
References: <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu> <25e057c00901150204x61c54d9fl91afe23477d1f12f@mail.gmail.com> <496F0F5E.3080404@kernel.org> <20090115113230.GH22850@elte.hu> <496F1FA6.6050204@kernel.org> <20090115122222.GI22850@elte.hu> <496F3577.4020303@kernel.org> <20090115133206.GA31416@elte.hu> <20090115133916.GA3417@elte.hu>
In-Reply-To: <20090115133916.GA3417@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Jan 2009 21:54:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> FYI, -tip testing found the following bug with your percpu stuff:
>>
>> There's an early exception during bootup, on 64-bit x86:
>>
>>   PANIC: early exception 0e rip 10:ffffffff80276855: error ? cr2 6688
>>
>>  - gcc version 4.3.2 20081007 (Red Hat 4.3.2-6) (GCC) 
>>  - binutils-2.18.50.0.6-2.x86_64
>>
>> config attached. You can find the disassembly of lock_release_holdtime() 
>> below - that's where it crashed:
> 
> Gut feeling: we must have gotten a window where the PDA is not right. Note 
> how it crashes in lock_release_holdtime() - that is CONFIG_LOCK_STAT 
> instrumentation - very lowlevel and pervasive. Function tracing is also 
> enabled although it should be inactive at the early stages.
> 
> So i'd take a good look at the PDA setup portion of the boot code, and see 
> whether some spinlock acquire/release can slip in while the 
> PDA/percpu-area is not reliable.

Heh... I tought I got this covered pretty good.  I'll get onto
debugging in a few hours.  Thanks for testing.

-- 
tejun
