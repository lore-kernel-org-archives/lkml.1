Return-Path: <linux-kernel-owner+w=401wt.eu-S1763508AbXKNFp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763508AbXKNFp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 00:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760213AbXKNFpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 00:45:49 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:33082 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760083AbXKNFps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 00:45:48 -0500
Message-ID: <473A8B97.5050909@acm.org>
Date: Tue, 13 Nov 2007 22:45:59 -0700
From: Zan Lynx <zlynx@acm.org>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: 2.6.24-rc2-mm1
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>	<473A6E72.60503@googlemail.com> <20071113205544.2a7743b4.akpm@linux-foundation.org>
In-Reply-To: <20071113205544.2a7743b4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20071113/1IsB4G-0005Ug-Iy-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
[cut]
> hm, that was supposed to shut itself off after 100 messages:
> 
> 	if (unlikely(clone_flags & (CLONE_DETACHED|CLONE_STOPPED))) {
> 		static int __read_mostly count = 100;
> 
> 		if (count && printk_ratelimit()) {
> 			char comm[TASK_COMM_LEN];
> 
> 			count--;
> 			printk(KERN_INFO "fork(): process `%s' used deprecated "
> 					"clone flags 0x%lx\n",
> 				get_task_comm(comm, current),
> 				clone_flags & (CLONE_DETACHED|CLONE_STOPPED));
> 		}
> 	}
> 
> I don't see how you got 151 instances.  I guess I'm having another stupid
> day.

It looks like a simple race, two threads do count-- before doing 
if(count), resulting in an almost infinite loop.  Probably.

atomic_test_and_dec might work.







