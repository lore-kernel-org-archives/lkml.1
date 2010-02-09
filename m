Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab0BIUWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 15:22:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33082 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975Ab0BIUWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 15:22:49 -0500
Date: Tue, 9 Feb 2010 12:21:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 17/35] sparsemem: put mem map for one node together.
Message-Id: <20100209122127.7a33cd24.akpm@linux-foundation.org>
In-Reply-To: <1265743966-17065-18-git-send-email-yinghai@kernel.org>
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
	<1265743966-17065-18-git-send-email-yinghai@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Feb 2010 11:32:28 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> +#ifdef CONFIG_NO_BOOTMEM
> +		free_early(__pa(vmemmap_buf_start), __pa(vmemmap_buf_end));
> +		if (vmemmap_buf_start < vmemmap_buf) {
> +			char name[15];
> +
> +			memset(name, 0, sizeof(name));

Is the memset actually needed?

> +			snprintf(name, 15, "MEMMAP %d", nodeid);

s/15/sizeof(name)/

> +			reserve_early_without_check(__pa(vmemmap_buf_start),
> +						    __pa(vmemmap_buf), name);
> +		}
> +#else
