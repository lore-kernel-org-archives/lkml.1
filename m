Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbZI3Ubl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbZI3Ubl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbZI3Ubk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:31:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbZI3Ubj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:31:39 -0400
Date: Wed, 30 Sep 2009 13:30:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       mark.langsdorf@amd.com
Subject: Re: use after free of struct powernow_k8_data
Message-Id: <20090930133059.995c34b4.akpm@linux-foundation.org>
In-Reply-To: <20090924165125.7cf51a1f@leela>
References: <20090924165125.7cf51a1f@leela>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 16:51:25 +0200
Michal Schmidt <mschmidt@redhat.com> wrote:

> Hello,
> 
> After resume from suspend I get:
> 
> =============================================================================
> BUG kmalloc-256: Poison overwritten
> -----------------------------------------------------------------------------
> 
> INFO: 0xffff880073bf1bb0-0xffff880073bf1bb7. First byte 0x12 instead of 0x6b
> INFO: Allocated in powernowk8_cpu_init+0x72/0xc27 [powernow_k8] age=290 cpu=0 pid=1782
> INFO: Freed in powernowk8_cpu_exit+0x6b/0x88 [powernow_k8] age=289 cpu=0 pid=1782
> INFO: Slab 0xffffea0002f059e8 objects=12 used=10 fp=0xffff880073bf1b88 flags=0x200000000000c3
> INFO: Object 0xffff880073bf1b88 @offset=2952 fp=0xffff880073bf1e18
> 
> Bytes b4 0xffff880073bf1b78:  ec 77 fe ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a __w____....ZZZZZZZZ
>   Object 0xffff880073bf1b88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880073bf1b98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
>   Object 0xffff880073bf1ba8:  6b 6b 6b 6b 6b 6b 6b 6b 12 00 00 00 0c 00 00 00 kkkkkkkk........
>   Object 0xffff880073bf1bb8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> 
> The overwritten values correspond to the currvid (0x12) and currfid (0x0c)
> fields if struct powernow_k8_data. Earlier in dmesg these exact values
> can be seen:
> 
> powernow-k8: table matched fid 0xc, giving vid 0x12
> powernow-k8: target matches current values (fid 0xc, vid 0x12)
> 
> It seems that something called query_current_values_with_pending_wait()
> while the struct was already freed.
> 
> It is perfectly reproducible. The kernel is the latest from git
> (94a8d5caba74211ec76dac80fc6e2d5c391530df).
> I'm attaching the full dmesg and .config.
> 

Do you know if this is a regression?  If so, since which kernel version?

Thanks.
