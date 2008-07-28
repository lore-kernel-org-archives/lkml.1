Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbYG1Ixu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbYG1Ixu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 04:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYG1Ixb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 04:53:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57075 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbYG1Ixa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 04:53:30 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <3950798.1217234354197.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 28 Jul 2008 17:39:14 +0900 (JST)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Re: [PATCH 1/2][-mm][resend] res_counter limit change support ebusy
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       balbir@linux.vnet.ibm.com, xemul@openvz.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080722014043.92272350.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <20080722014043.92272350.akpm@linux-foundation.org>
 <20080714171154.e1cc9943.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
>On Mon, 14 Jul 2008 17:11:54 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fuji
tsu.com> wrote:
>
>> +static inline int res_counter_set_limit(struct res_counter *cnt,
>> +	unsigned long long limit)
>> +{
>> +	unsigned long flags;
>> +	int ret = -EBUSY;
>> +
>> +	spin_lock_irqsave(&cnt->lock, flags);
>> +	if (cnt->usage < limit) {
>> +		cnt->limit = limit;
>> +		ret = 0;
>> +	}
>> +	spin_unlock_irqrestore(&cnt->lock, flags);
>> +	return ret;
>> +}
>
>Need I say it?  This function is waaaaaay too large to be inlined.

Will rework and make this uninlined. (in this week)

Thanks,
-Kame

