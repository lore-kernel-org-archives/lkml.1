Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbYGGXxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbYGGXxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 19:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbYGGXxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 19:53:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56304 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbYGGXxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 19:53:30 -0400
Message-ID: <4872AC70.8030704@kernel.org>
Date: Mon, 07 Jul 2008 16:53:20 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [0/10] Use 64bit x86 machine check code for 32bit too
 v2
References: <20080708110.487722491@firstfloor.org>
In-Reply-To: <20080708110.487722491@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied to -tip as x86/unify-mce.

Thanks!

	-hpa


Andi Kleen wrote:
> This patchkit uses the 64bit machine check code which is better in many
> ways on 32bit x86 too. This is also the basis for some future machine
> check work.
> 
> The 64bit machine check code is in many ways much better than 
> the 32bit machine check code: it is more specification compliant,
> is cleaner, only has a single code base versus one per CPU, 
> has better infrastructure for recovery, has a cleaner way to communicate
> with user space etc. etc.
> 
> It requires testing especially on older systems (on newer
> ones it should be already tested well in 64bit systems). 
> 
> The patchkit contains several parts:
> - It ports over a few needed quirks (for older Intel and older
> AMD CPUs) to the 64bit kernel.
> - It changes the 64bit code to be 32bit clean in its data structures
> (mostly just unsigned long -> u64 where needed) 
> - It drops some unused functionality that cannot be easily implemented on 32bit
> and didn't seem worth ifdefing
> 
> Tested by doing some software level error injection on a few
> different machines
> 
> I request this code is merged into the appropiate tree for linux-next
> for wider testing. It's not .27 ready, but hopefully .28, but it requires
> wider exposure now.
> 
> v2: Fix compilation problems noted by hpa in some configurations
>     Fix strict_strtoul() conversion
> 
> -Andi 
> 
