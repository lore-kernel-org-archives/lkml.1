Return-Path: <linux-kernel-owner+w=401wt.eu-S1762633AbXHHM0C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762633AbXHHM0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 08:26:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbXHHMZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 08:25:54 -0400
Received: from anchor-post-35.mail.demon.net ([194.217.242.85]:3173 "EHLO
	anchor-post-35.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754670AbXHHMZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 08:25:53 -0400
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
From: richard kennedy <richard@rsk.demon.co.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       torvalds@linux-foundation.org
In-Reply-To: <20070803123712.987126000@chello.nl>
References: <20070803123712.987126000@chello.nl>
Content-Type: text/plain
Date: Wed, 08 Aug 2007 13:25:47 +0100
Message-Id: <1186575947.3106.23.camel@castor.rsk.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-03 at 14:37 +0200, Peter Zijlstra wrote:
> Per device dirty throttling patches
> 
> These patches aim to improve balance_dirty_pages() and directly address three
> issues:
>   1) inter device starvation
>   2) stacked device deadlocks
>   3) inter process starvation
<snip>
Hi Peter,
I've been testing your patch with a simple test case that copies a 3GB
file from sda -> sda, and copies a 1GB file from sda -> sdb.
the script is roughly this :-

dd bs=64k if=[sda]/data3g of=[sda]/temp_data3g &
sleep 60
dd bs=64k if=[sda]/data1g of=[sdb]/temp_data1g &
wait
sleep 200

On my amd64x2 desktop machine where sda is a sata 250 GB drive & sdb is
an ide 300 GB drive.

Running this test 5 times gives
2.6.23-rc1-mm2
1GB copy MB/s	3GB copy MB/s
16.2		16.1
15.2		14.6
17.3		14.6
18.0		14.5
19.0		14.6

2.6.23-rc1-mm2+pddt_patch
1GB copy MB/s	3GB copy MB/s
23.0		14.7
24.0		14.6
20.4		14.8
22.6		14.5
23.2		14.5

This is on a standard desktop machine so there are lots of other
processes running on it, and although there is a degree of variability
in the numbers,they are very repeatable and your patch always out
performs the stock mm2.
looks good to me

Richard
  






