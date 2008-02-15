Return-Path: <linux-kernel-owner+w=401wt.eu-S934024AbYBOAs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934024AbYBOAs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934924AbYBOAm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:42:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37090 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934900AbYBOAm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:42:56 -0500
Date: Thu, 14 Feb 2008 16:42:16 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] latencytop: fix kernel panic and memory leak on proc
Message-ID: <20080214164216.45ebf51f@laptopd505.fenrus.org>
In-Reply-To: <47B4C5E7.5000802@ct.jp.nec.com>
References: <47B4C5E7.5000802@ct.jp.nec.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008 14:51:19 -0800
Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> Hi,
> 
> I posted 2 patches to fix kernel panic and memory leak.
> http://lkml.org/lkml/2008/2/14/282
> http://lkml.org/lkml/2008/2/14/283
> 
> But, I think this patch is better than old ones.
> 
> ---
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Reading /proc/<pid>/latency or /proc/<pid>/task/<tid>/latency could
> cause NULL pointer dereference.
> 
> In lstats_open(), get_proc_task() can return NULL, in which case the
> kernel will oops at lstats_show_proc() because m->private is NULL.
> 
> This can be reproduced by the follwoing script.
> while :
> do
> 	bash -c 'ls > ls.$$' &
> 	pid=$!
> 	cat /proc/$pid/latency &
> 	cat /proc/$pid/latency &
> 	cat /proc/$pid/latency &
> 	cat /proc/$pid/latency
> done
> 
> And the task struct which gotten by get_proc_task() is never put.
> put_task_struct() should be called.
> 
> This patch changes the private is used to store inode, and the task
> struct will be gotten and putted in read or write function.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>


Fine with me; Ingo please merge
Thanks for working on this!

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
