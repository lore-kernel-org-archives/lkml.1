Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbZCRCbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbZCRCbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 22:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbZCRCbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 22:31:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63770 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbZCRCbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 22:31:11 -0400
Message-ID: <49C05C94.7030104@cn.fujitsu.com>
Date: Wed, 18 Mar 2009 10:29:40 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>, jkosina@suse.cz, gregkh@suse.de,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: 29-rc-mmotm - HID/USB wedge w/ WARNING: at kernel/workqueue.c:371
References: <6648.1237271589@turing-police.cc.vt.edu>            <20090317135424.9151c4f8.akpm@linux-foundation.org> <37742.1237327272@turing-police.cc.vt.edu>
In-Reply-To: <37742.1237327272@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Tue, 17 Mar 2009 13:54:24 PDT, Andrew Morton said:
> 
>> It's an error in workqueue-avoid-recursion-in-run_workqueue.patch, methinks.
> 
> Thanks for the diagnosis - I got as far as realizing that any backtrace that
> included flush_cpu_workqueue() and worker_thread() had a problem and got
> stuck there.
> 

It's dangerous when we allow recursion in run_workqueue().

If it's hard for you avoid flush_scheduled_work() in
keventd's work fuction by other fix, you can create
another workqueue to handle your works, IMO.

Thanks
Lai jiangshan

