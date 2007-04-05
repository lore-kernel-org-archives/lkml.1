Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbXDEM1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbXDEM1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 08:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbXDEM1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 08:27:06 -0400
Received: from [59.42.214.131] ([59.42.214.131]:4120 "HELO www.anyka.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1766969AbXDEM1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 08:27:05 -0400
X-Greylist: delayed 1899 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2007 08:27:04 EDT
From: "qingxiaoming" <qing_xiaoming@anyka.com>
To: <linux-kernel@vger.kernel.org>
Subject: Not Initialize the shrinker->list after kmalloc() in mm/vmscan.c(V2.6.12)?
Date: Thu, 5 Apr 2007 19:55:01 +0800
Message-ID: <003801c77779$3df8c450$160710ac@qingxiaoming>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1896
Thread-Index: Acd2s3qD1Rbm572/T7a0C6VDdoQJSQAwq5+QAADBaHA=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all:
I am reading the function set_shrinker() in mm/vmscan.c of V2.6.12, and I
have a question about the not initialization of list_head,

/*
 * Add a shrinker callback to be called from the vm
 */
struct shrinker *set_shrinker(int seeks, shrinker_t theshrinker)
{
        struct shrinker *shrinker;

        shrinker = kmalloc(sizeof(*shrinker), GFP_KERNEL);
        if (shrinker) {
	        shrinker->shrinker = theshrinker;
	        shrinker->seeks = seeks;
	        shrinker->nr = 0;
	        down_write(&shrinker_rwsem);
	        list_add_tail(&shrinker->list, &shrinker_list);
	        up_write(&shrinker_rwsem);
	}
	return shrinker;
}

As above, the shrinker is allocated from kmalloc, coming from slab
allocator,the list in shrinker is not initialized, directly list_add_tail()
to shrinker_list, don't need to INIT_LIST_HEAD(shrinker->list)?

Thanks,
Best Regards!
Xiaoming.Qing


