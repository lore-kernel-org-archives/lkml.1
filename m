Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab0B1GIq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 01:08:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:36958 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922Ab0B1GIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 01:08:45 -0500
Message-ID: <4B8A0AAA.6090607@kernel.org>
Date: Sun, 28 Feb 2010 15:18:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Subject: Re: [PATCH] workqueue: Fix a compile warning in work_busy
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <20100228010002.GB13594@kryten>
In-Reply-To: <20100228010002.GB13594@kryten>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 28 Feb 2010 06:07:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/28/2010 10:00 AM, Anton Blanchard wrote:
> Ensure ret is initialised to avoid the following warning:
> 
> kernel/workqueue.c: In function ‘work_busy’:
> kernel/workqueue.c:2697: warning: ‘ret’ may be used uninitialized in this function

Thanks a lot for catching this.  gcc 4.4.1 building for x86_64 doesn't
seem to notice that.  gcc has been relatively reliable in catching
these mistakes.  I wonder what made it slip.  My cross gcc 4.3.3 for
powerpc catches it.  Strange.  Anyways, fix folded into
0035-workqueue-implement-several-utility-APIs.patch

Thank you.

-- 
tejun
