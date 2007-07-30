Return-Path: <linux-kernel-owner+w=401wt.eu-S937908AbXG3KtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937908AbXG3KtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 06:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbXG3KtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 06:49:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbXG3KtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 06:49:12 -0400
Message-ID: <46ADC220.1090703@kernel.sg>
Date: Mon, 30 Jul 2007 18:49:04 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/partitions/check.c: add_partition() warning fixes
 (take 2)
References: <20070730094755.GA25285@kernel.sg> <20070730123045.4a3f859c@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070730123045.4a3f859c@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Mon, 30 Jul 2007 17:47:55 +0800,
> Eugene Teo <eugeneteo@kernel.sg> wrote:
> 
>> +err_out_del_link:
>> +	sysfs_remove_link(&p->kobj, "subsystem");
>> +err_out_del_kobj:
>> +	if (!disk->part_uevent_suppress)
>> +		kobject_uevent(&p->kobj, KOBJ_REMOVE);
>> +	kobject_put(&p->kobj);
>> +err_out:
>> +	kfree(p);
>>  }
> 
> No, this is wrong. You need to move the put behind err_out and remove
> the kfree. (The release function will take care of p.)

503 void kobject_put(struct kobject * kobj)
504 {
505         if (kobj)
506                 kref_put(&kobj->kref, kobject_release);
[...]
 52 int kref_put(struct kref *kref, void (*release)(struct kref *kref))
 53 {
[...]
 57         if (atomic_dec_and_test(&kref->refcount)) {
 58                 release(kref);
 59                 return 1;

Nod, thanks for your guidance.

Eugene
