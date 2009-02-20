Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbZBTA4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbZBTA4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 19:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758538AbZBTAzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 19:55:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758407AbZBTAzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 19:55:38 -0500
Date: Thu, 19 Feb 2009 16:55:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: sonic zhang <sonic.adi@gmail.com>
Cc: jason.wessel@windriver.com, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH] [kgdb] Switch master cpu after gdb thread command for
 SMP (v4)
Message-Id: <20090219165527.2ad1a889.akpm@linux-foundation.org>
In-Reply-To: <1234949874.17467.6.camel@eight.analog.com>
References: <1234949874.17467.6.camel@eight.analog.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009 17:37:54 +0800
sonic zhang <sonic.adi@gmail.com> wrote:

> This is the updated kgdb SMP patch, which is tested on blackfin bf561 dual core
> system. A new bug is fixed, which causes debugging halt in SMP kernel if a
> breakpoint is hit and cpu is switched in gdb before continue running kernel.
> 
>    In blackfin SMP architecture, different core has its own L1 SRAM and MMR
>    memory, which code running on the other core can't access. In current kgdb
>    impelemntation, cpus are represented by thread with minus prefix.
> 
> If user run thread command in gdb to switch to the thread of the other cpu,
> kgdb should:
> 1. send IPI signal to master cpu
> 2. release the specific passive cpu waiting in IPI handler
> 3. exit kgdb exception loop on master cpu and trap into kgdb wait in IPI handler
> 4. trap the released passive cpu into kgdb exception in IPI handler
> 

x86_64 allmodconfig:

kernel/kgdb.c: In function 'kgdb_wait':
kernel/kgdb.c:589: error: 'KGDB_THR_PROC_SWAP' undeclared (first use in this function)
kernel/kgdb.c:589: error: (Each undeclared identifier is reported only once
kernel/kgdb.c:589: error: for each function it appears in.)
kernel/kgdb.c: In function 'gdb_cmd_query':
kernel/kgdb.c:1087: error: 'KGDB_THR_PROC_SWAP' undeclared (first use in this function)
kernel/kgdb.c: In function 'gdb_cmd_task':
kernel/kgdb.c:1113: error: 'KGDB_THR_PROC_SWAP' undeclared (first use in this function)
kernel/kgdb.c: In function 'gdb_cmd_thread':
kernel/kgdb.c:1163: error: 'KGDB_THR_PROC_SWAP' undeclared (first use in this function)
kernel/kgdb.c: In function 'gdb_serial_stub':
kernel/kgdb.c:1275: error: 'KGDB_THR_PROC_SWAP' undeclared (first use in this function)
kernel/kgdb.c: In function 'kgdb_handle_exception':
kernel/kgdb.c:1575: error: 'KGDB_THR_PROC_SWAP' undeclared (first use in this function)
kernel/kgdb.c: In function 'kgdb_nmicallback':
kernel/kgdb.c:1606: warning: suggest parentheses around && within ||
kernel/kgdb.c:1606: warning: suggest parentheses around && within ||
kernel/kgdb.c:1606: warning: suggest parentheses around && within ||
