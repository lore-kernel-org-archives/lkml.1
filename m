Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbYFTWWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbYFTWWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 18:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbYFTWWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 18:22:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbYFTWWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 18:22:37 -0400
Date: Fri, 20 Jun 2008 18:22:33 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: stack overflow on Sparc64
In-Reply-To: <20080620.144736.224107106.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0806201819430.25997@engineering.redhat.com>
References: <20080620.142034.30884440.davem@davemloft.net>
 <Pine.LNX.4.64.0806201723120.14221@engineering.redhat.com>
 <20080620.144424.168785883.davem@davemloft.net> <20080620.144736.224107106.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008, David Miller wrote:

> From: David Miller <davem@davemloft.net>
> Date: Fri, 20 Jun 2008 14:44:24 -0700 (PDT)
>
>> I agree on both counts.  Although I'm curious what the average stack
>> frame sizes look like on x86_64 and i386, and also how this area
>> appears on powerpc.
>
> I also one to mention in passing that another thing we can do to
> help deep call stack sizes is to make call chains more tail-call
> friendly when possible.

... and remove -fno-optimize-sibling-calls?:

Makefile:
ifdef CONFIG_FRAME_POINTER
KBUILD_CFLAGS   += -fno-omit-frame-pointer -fno-optimize-sibling-calls
else
KBUILD_CFLAGS   += -fomit-frame-pointer
endif

--- maybe it could be better to remove it, instead of some inlining that I 
made. Or do you see a situation when for debugging purpose, user would 
want -fno-optimize-sibling-calls?

Mikulas
