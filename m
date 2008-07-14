Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbYGNLvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbYGNLvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 07:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbYGNLv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 07:51:29 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:20028 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYGNLv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 07:51:28 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout
Date: Mon, 14 Jul 2008 13:51:25 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
References: <487B05CE.1050508@jp.fujitsu.com>
In-Reply-To: <487B05CE.1050508@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807141351.25092.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 14. Juli 2008 schrieb Hidetoshi Seto:
> +	/* Wait all others come to life */
> +	while (cpus_weight(prepared_cpus) != num_online_cpus() - 1) {
> +		if (time_is_before_jiffies(limit))
> +			goto timeout;
> +		cpu_relax();
> +	}
> +

Hmm. I think this could become interesting on virtual machines. The hypervisor 
might be to busy to schedule a specific cpu at certain load scenarios. This 
would cause a failure even if the cpu is not really locked up. We had similar 
problems with the soft lockup daemon on s390. 

It would be good to not-use wall-clock time, but really used cpu time instead. 
Unfortunately I have no idea, if that is possible in a generic way.
Heiko, any ideas?
