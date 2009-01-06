Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbZAFIOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbZAFIOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 03:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbZAFIN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 03:13:58 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:62156 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbZAFIN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 03:13:57 -0500
Message-Id: <200901060813.n068DI3Y023188@www262.sakura.ne.jp>
Subject: Re: [TOMOYO #14 (mmotm 2008-12-30-16-05) 02/10] Singly linked list implementation.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: jmorris@namei.org
Cc: akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 06 Jan 2009 17:13:18 +0900
References: <20090101050741.372438529@I-love.SAKURA.ne.jp> <20090101050939.802554261@I-love.SAKURA.ne.jp> <alpine.LRH.1.10.0901051926130.16049@tundra.namei.org>
In-Reply-To: <alpine.LRH.1.10.0901051926130.16049@tundra.namei.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 06012009 #1406384, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


James Morris wrote:
> This has a technical ack from Paul, but what about Linus' long-standing 
> objection to singly-linked lists in the kernel?  I'm sure this has been 
> discussed re. your patches, but I can't find a reference.
I couldn't find one neither. (What does "re." mean?)

But optimistically speaking, there are many in-tree users who define "struct"
without "prev" pointer.

  # grep -hr 'struct [a-zA-Z0-9_]* \*next;' linux-2.6.28/include/linux/ | wc -l
  42
  # grep -hr 'struct [a-zA-Z0-9_]* \*prev;' linux-2.6.28/include/linux/ | wc -l
  7

Not all structures listed below are used as singly linked list,
but many of them are used as singly linked list.

  struct sched_class;
  struct acpi_pci_driver;
  struct adb_request;
  struct atalk_route;
  struct core_thread;
  struct dma_async_tx_descriptor;
  struct erase_info;
  struct esp_pio_buffer;
  struct fdtable;
  struct floppy_raw_cmd;
  struct ftrace_ops;
  struct hdlc_proto;
  struct hwif_s;
  struct ippp_buf_queue;
  struct irqaction;
  struct isdn_net_local_s;
  struct kcore_list;
  struct mfc6_cache;
  struct mfc_cache;
  struct nls_table;
  struct notifier_block;
  struct page_list;
  struct pbe;
  struct phone_device;
  struct pnp_id;
  struct r3964_block_header;
  struct r3964_client_info;
  struct r3964_message;
  struct rcu_head;
  struct resource_list;
  struct sched_group;
  struct sdio_func_tuple;
  struct tasklet_struct;
  struct tty_buffer;
  struct xor_block_template;

Thus, I believe it is acceptable that TOMOYO uses singly linked list
unless Linus comes out and yell "No!".

Regards.
