Return-Path: <linux-kernel-owner+w=401wt.eu-S1764135AbYESWL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764135AbYESWL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761139AbYESWIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:08:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763367AbYESWIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:08:14 -0400
Date: Mon, 19 May 2008 15:06:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, ltp-coverage@lists.sourceforge.net,
       sam@ravnborg.org, rusty@rustcorp.com.au, oberparleiter@googlemail.com
Subject: Re: [PATCH 1/7] kernel: call constructors
Message-Id: <20080519150640.c61dca49.akpm@linux-foundation.org>
In-Reply-To: <48313DA2.2090108@de.ibm.com>
References: <48313DA2.2090108@de.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 10:43:14 +0200
Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:

> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> 
> Call constructors during kernel init and module load. Required by the
> gcov profiling infrastructure: gcc's profiling code uses constructors
> to register profiling data structures.
> 
> Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> ---
>  arch/powerpc/kernel/vmlinux.lds.S |    3 +++
>  include/asm-generic/sections.h    |    1 +
>  include/asm-generic/vmlinux.lds.h |    5 +++++
>  include/linux/init.h              |    2 ++
>  include/linux/module.h            |    3 +++
>  init/main.c                       |   10 ++++++++++
>  kernel/module.c                   |   13 +++++++++++++

What happens with architectures which do not use
include/asm-generic/vmlinux.lds.h?  A quicky grep points at

arch/m68k/kernel/vmlinux.lds.S
arch/sh/kernel/vmlinux.lds.S
arch/um/kernel/vmlinux.lds.S
