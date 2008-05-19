Return-Path: <linux-kernel-owner+w=401wt.eu-S1764951AbYESWDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764951AbYESWDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbYESWCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:02:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53062 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764519AbYESWCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:02:06 -0400
Message-ID: <4831F89F.5060106@zytor.com>
Date: Mon, 19 May 2008 15:01:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] asm-generic/int-ll64.h: always provide __{s,u}64
References: <20080519215452.GK17716@cs181133002.pp.htv.fi>
In-Reply-To: <20080519215452.GK17716@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Several compilers offer "long long" without claiming to support C99.
> 
> Considering how frequent __s64/__u64 are used our userspace headers are 
> anyway unusable without __s64/__u64 available.
> 
> Always offer __s64/__u64 to non-gcc non-C99 compilers - if they provide 
> "long long" that makes the headers compiling and if they don't they are 
> anyway screwed.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

This makes sense to me (I did, however, not want to make that change 
part of the same changeset - one change at a time.)

The main reason for not just blindly using "long long" has to do with 
the use of gcc -ansi -pedantic in userspace, which is already taken care 
of by the use of __extension__ in the __GNUC__ clause.

Acked-by: H. Peter Anvin <hpa@zytor.com>

