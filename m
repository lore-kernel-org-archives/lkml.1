Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111Ab0BYKZD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:25:03 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49496 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759011Ab0BYKZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:25:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EVbXxkPwr7ywOFdEMSzWnAFbgzR+tbHtxoqNDLZXKlhqTLawGsd4qKundWWJCZJ1QJ
         VWyVK3uKaLmjK6zGRbO4gfE8o6aFNHTjt/7NVA+N1/QN7jNXwqXc4j+MNGvzeYTfSNoX
         V7EAqp4kShWtD6ZlSIUcQo8sxwbeXHVybgXVE=
Message-ID: <4B8650A2.9060803@gmail.com>
Date: Thu, 25 Feb 2010 19:27:46 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Samu Onkalo <samu.p.onkalo@nokia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] workqueues: microoptimize set_wq_data()
References: <20100224202035.GA26991@redhat.com> <4B85EA24.5020409@kernel.org>
In-Reply-To: <4B85EA24.5020409@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On 02/25/2010 12:10 PM, Tejun Heo wrote:
>> @@ -220,12 +220,9 @@ struct cpu_workqueue_struct *wq_per_cpu(
>>  static inline void set_wq_data(struct work_struct *work,
>>  				struct cpu_workqueue_struct *cwq)
>>  {
>> -	unsigned long new;
>> -
>> -	BUG_ON(!work_pending(work));
>> -
>> -	new = (unsigned long) cwq | (1UL << WORK_STRUCT_PENDING);
>> +	unsigned long new = (unsigned long)cwq;
>>  	new |= WORK_STRUCT_FLAG_MASK & *work_data_bits(work);
>> +	BUG_ON(!(new & (1UL << WORK_STRUCT_PENDING)));
>>  	atomic_long_set(&work->data, new);
> 
> Will apply under cmwq patches for the next merge window.

Turns out I already have a patch which kills the second
work_data_bits() dereferencing in the series.  The first one is now in
the cmwq series which is about to be posted again.

Thanks.

-- 
tejun
