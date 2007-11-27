Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbXK0HmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbXK0HmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 02:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbXK0HmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 02:42:17 -0500
Received: from gate.crashing.org ([63.228.1.57]:36400 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbXK0HmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 02:42:16 -0500
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
Message-Id: <F81BD9A7-9D76-4C2C-AF80-AAA3F70F061E@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20071127001431.688565525@sgi.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [patch 11/14] Powerpc: Use generic per cpu
Date: Tue, 27 Nov 2007 01:41:55 -0600
References: <20071127001407.859743255@sgi.com> <20071127001431.688565525@sgi.com>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 26, 2007, at 6:14 PM, Christoph Lameter wrote:

> Powerpc has a way to determine the address of the per cpu area of the
> currently executing processor via the paca and the array of per cpu
> offsets is avoided by looking up the per cpu area from the remote
> paca's (copying x86_64).
>
> Cc: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
>
> ---
> include/asm-powerpc/percpu.h |   19 -------------------
> 1 file changed, 19 deletions(-)
>
> Index: linux-2.6/include/asm-powerpc/percpu.h
> ===================================================================
> --- linux-2.6.orig/include/asm-powerpc/percpu.h	2007-11-24  
> 10:27:31.088350556 -0800
> +++ linux-2.6/include/asm-powerpc/percpu.h	2007-11-24  
> 10:29:20.752350757 -0800
> @@ -16,25 +16,6 @@
> #define __my_cpu_offset() get_paca()->data_offset
> #define per_cpu_offset(x) (__per_cpu_offset(x))

This concerns me.  paca doesn't exist on all PPC platforms.

- k
