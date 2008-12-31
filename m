Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbYLaAhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbYLaAhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 19:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbYLaAhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 19:37:24 -0500
Received: from mail.lang.hm ([64.81.33.126]:51565 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbYLaAhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 19:37:23 -0500
Date: Tue, 30 Dec 2008 17:39:29 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
In-Reply-To: <87k59hur5f.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.1.10.0812301737320.16936@asgard.lang.hm>
References: <alpine.DEB.1.10.0812301416550.16847@asgard.lang.hm> <87k59hur5f.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Dec 2008, Andi Kleen wrote:

> david@lang.hm writes:
>>
>> doing a grep through System.map for the address that appears in the
>> error returns nothing
>
> This might be obvious, but you can't grep directly for these addresses
> because System.map contains the starting addresses of functions only
> and normally the reported address is somewhere in the middle of a
> function. So you instead have to look for the highest number lower or equal
> the address from the exception.

thanks, this was not obvious to me

the -2 error maps to

ffffffff8099e4c1 T free_bootmem_node
ffffffff8099e4e5 t alloc_bootmem_core
ffffffff8099e774 t ___alloc_bootmem_nopanic


the first error maps to

ffffffff809c2de4 T free_bootmem_node
ffffffff809c2e08 t alloc_bootmem_core
ffffffff809c3097 t ___alloc_bootmem_nopanic


so it looks like this is in alloc_bootmem_core in both cases.

David Lang
