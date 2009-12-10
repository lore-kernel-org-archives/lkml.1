Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbZLJAsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbZLJAsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbZLJAsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:48:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39580 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbZLJAsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:48:36 -0500
Message-ID: <4B204521.7030204@zytor.com>
Date: Wed, 09 Dec 2009 16:47:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, torvalds@linux-foundation.org,
       jeremy@goop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] x86: Merge pt_regs using syscalls
References: <1260403316-5679-1-git-send-email-brgerst@gmail.com>
In-Reply-To: <1260403316-5679-1-git-send-email-brgerst@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2009 04:01 PM, Brian Gerst wrote:
> This patch set converts the 32-bit syscalls that need pt_regs to
> match the same prototype as 64-bit, using regparm(3) and adding 
> the pt_regs pointer as an extra argument.  This allows these
> syscalls to be merged.
> 
> [PATCH 1/6] x86, 32-bit: Add new pt_regs stubs
> [PATCH 2/6] x86: Merge sys_iopl
> [PATCH 3/6] x86: Merge sys_execve
> [PATCH 4/6] x86: Merge sys_sigaltstack
> [PATCH 5/6] x86, 32-bit: Convert sys_vm86 & sys_vm86old
> [PATCH 6/6] x86: Merge sys_clone

I have applied this series to tip:x86/asm with the addition of avoiding
the extra pipeline serialization; assuming it doesn't break anything we
can consider if we can push it for .33.  I really like the series,
though; it is very clean and does the right thing.

	-hpa
