Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbYDHL3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbYDHL3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbYDHLV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:21:56 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:34935 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbYDHLVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:21:55 -0400
To: Nuno Pais Fernandes <npf@eurotux.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: proc_stack for x86_64 (spinning process)
From: Andi Kleen <andi@firstfloor.org>
References: <200804081136.41876.npf@eurotux.com>
Date: Tue, 08 Apr 2008 13:21:53 +0200
In-Reply-To: <200804081136.41876.npf@eurotux.com> (Nuno Pais Fernandes's message of "Tue, 8 Apr 2008 11:36:41 +0100")
Message-ID: <87myo4pp66.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Apr 2008 11:15:10.0955 (UTC) FILETIME=[CF5B6BB0:01C89969]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nuno Pais Fernandes <npf@eurotux.com> writes:

> Hi,
>
> I have a spinning process that it's locking my server (eating 100% CPU). I 
> can't kill it even with kill -9
>
> I'm trying to use proc_stack to check what's the problem, compiling the kernel 
> with
>
> http://linuxhacker.ru/~nikita/patches/2.6.12-rc6/2005.06.11/vm_07-proc-stack.patch
>
> But this patch is only for x86 as my arch is x86_64. Does anyone know if 
> there's a patch for x86_64?

The standard way to handle that is to just do 

echo 1 > /proc/sys/kernel/sysrq 
echo t > /proc/sysrq-trigger

and then look for the process backtrace in the kernel log.

Another alternative is to use crash to take a live dump and then analyse that
using crash.

-Andi
