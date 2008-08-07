Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYHGQAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYHGQAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 12:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbYHGQA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 12:00:27 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:59568 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbYHGQA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 12:00:26 -0400
Message-ID: <489B1BDC.1010504@s5r6.in-berlin.de>
Date: Thu, 07 Aug 2008 17:59:24 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] mdb-2.6.27-rc2-ia32-08-07-08.patch
References: <1300.69.2.248.210.1218119365.squirrel@webmail.wolfmountaingroup.com> <489B199B.40305@s5r6.in-berlin.de>
In-Reply-To: <489B199B.40305@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> jmerkey@wolfmountaingroup.com wrote:
>> ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.27-rc2-ia32-08-07-08.patch
...
>> +typedef struct _RLOCK 
>> +{
>> +#if defined(CONFIG_SMP)
>> +    spinlock_t lock;
>> +#endif
>> +    unsigned long flags;
>> +    unsigned long processor;
>> +    unsigned long count;    
>> +} rlock_t;
...
> The accessors rspin_lock() and rspin_try_lock() peek into spinlock_t and
> may therefore not be fully portable.  Also, they and rspin_unlock()
> don't look SMP safe:
...
>> +   if (rlock->lock.raw_lock.slock && rlock->processor == proc)

Correction:  They _are_ not portable.  Look at the first hit in
http://lxr.linux.no/linux+v2.6.26/+code=raw_spinlock_t .
-- 
Stefan Richter
-=====-==--- =--- --===
http://arcgraph.de/sr/
