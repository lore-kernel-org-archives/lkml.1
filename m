Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbYGNMe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbYGNMe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 08:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbYGNMet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 08:34:49 -0400
Received: from ozlabs.org ([203.10.76.45]:50471 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbYGNMes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 08:34:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout
Date: Mon, 14 Jul 2008 22:34:40 +1000
User-Agent: KMail/1.9.9
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>
References: <487B05CE.1050508@jp.fujitsu.com> <200807141351.25092.borntraeger@de.ibm.com>
In-Reply-To: <200807141351.25092.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807142234.40700.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 July 2008 21:51:25 Christian Borntraeger wrote:
> Am Montag, 14. Juli 2008 schrieb Hidetoshi Seto:
> > +	/* Wait all others come to life */
> > +	while (cpus_weight(prepared_cpus) != num_online_cpus() - 1) {
> > +		if (time_is_before_jiffies(limit))
> > +			goto timeout;
> > +		cpu_relax();
> > +	}
> > +
>
> Hmm. I think this could become interesting on virtual machines. The
> hypervisor might be to busy to schedule a specific cpu at certain load
> scenarios. This would cause a failure even if the cpu is not really locked
> up. We had similar problems with the soft lockup daemon on s390.

5 seconds is a fairly long time.  If all else fails we could have a config 
option to simply disable this code.

> It would be good to not-use wall-clock time, but really used cpu time
> instead. Unfortunately I have no idea, if that is possible in a generic
> way. Heiko, any ideas?

Ah, cpu time comes up again.  Perhaps we should actually dig that up again; 
Zach and Jeremy CC'd.

Thanks,
Rusty.
