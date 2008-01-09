Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbYAIFV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbYAIFV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 00:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbYAIFVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 00:21:49 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:14396 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYAIFVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 00:21:48 -0500
Date: Wed, 9 Jan 2008 06:21:44 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: More breakage in native_rdtsc out of line in git-x86 II
Message-ID: <20080109052144.GA21032@basil.nowhere.org>
References: <20080109035534.GA30321@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109035534.GA30321@basil.nowhere.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 09 Jan 2008 05:15:35.0697 (UTC) FILETIME=[AA52D010:01C8527E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think the problem is that the vsyscall/vdso code calls it through
> vread and for that it has to be exported. There seems to be also
> another bug with the old style vsyscalls not using the TSC vread
> that masks it on older glibc
> 
> Stepping with gdb through old style vgettimeofday() confirms that RDTSC is 
> not used.
> 
> A long time ago we had a similar problem once and it was because of a 
> problem exporting the vsyscall variables in vmlinux.lds.S -- looks like that 
> has reappeared.
> 
> I think the new glibc shows it because it uses the vDSO not 
> the older vsyscall and the new vDSO probably still works. Anyways haven't 
> investigated why that is in detail yet, but that's a separate 
> regression.

Actually that seems to be because the test system using the older 
glibc didn't use the TSC because it was marked unstable due a 
unsynchronized TSC. It should not have been -- this is a Core2 
dual core single socket. Will investigate later what happened
there.

-Andi
