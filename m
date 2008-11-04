Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbYKDJVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbYKDJVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 04:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbYKDJVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 04:21:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54610 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbYKDJVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 04:21:14 -0500
Date: Tue, 4 Nov 2008 10:19:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: Re: [patch] generic-ipi: fix the smp_mb() placement
Message-ID: <20081104091956.GI23790@elte.hu>
References: <20081029224229.GK30573@linux-os.sc.intel.com> <20081030185322.GE17822@elte.hu> <20081030202322.GM30573@linux-os.sc.intel.com> <490A9337.6090504@goop.org> <20081031093924.GG30317@elte.hu> <490AE820.1010301@goop.org> <20081031165334.GA10468@linux-os.sc.intel.com> <490B6AE8.3040700@goop.org> <20081103101736.GI13671@elte.hu> <490F8DC9.9000005@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490F8DC9.9000005@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> ok - so that makes it a v2.6.28 item i guess.
>>   
>
> The case Suresh is talking about was a fix to Xen itself, rather 
> than on the kernel side, so it doesn't need to be a .28 issue on 
> Xen's account.

ok - but still the portion of the fix that strengthens barriers looks 
obvious to have and there's little downside that i can see.

Suresh, you might want to split the patch(es) in two: get the barrier 
strengthening changes into v2.6.28 (to fix the x2apic bug), while the 
aspects that _weaken_ barriers can wait for v2.6.29.

With that it would be a 100% safe change for v2.6.28-rc4.

	Ingo
