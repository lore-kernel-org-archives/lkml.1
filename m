Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbYETQ1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbYETQ1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbYETQ0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:26:54 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43207 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbYETQ0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:26:53 -0400
Date: Tue, 20 May 2008 09:26:46 -0700
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>, manfred@colorfullife.com,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       akpm@linux-foundation.org
Subject: Re: [PATCH 7/9] Make idr_remove rcu-safe
Message-ID: <20080520162646.GA14707@tpepper-t42p.dolavim.us>
References: <20080507113553.395937000@bull.net> <20080507113737.562143000@bull.net> <20080514195925.GA8994@tpepper-t42p.dolavim.us> <482BE8DD.2020101@bull.net> <20080520052904.GA11326@tpepper-t42p.dolavim.us> <483277BE.6060207@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483277BE.6060207@bull.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 20 May at 09:03:26 +0200 Nadia.Derbey@bull.net said:
>> 60	 91581.07	158207.08	 797796.94	2970977.25
>> 61	 89209.40	160529.38	1202135.38	2538114.50
>> 62	 89008.45	167843.78	1305666.75	2274845.00
>> 63	 97753.17	177470.12	 733957.31	 363952.62
>> 64	102556.05	175923.56	1356988.88	 199527.83
>>
> Actually there are 2 numbers that bother me: those for the contended loops 
> on the patched kernel (63 and 64 threads) - the last 2 numbers in the 
> rightmost column.

> Did you have the opportunity to run that same test for 128 threads: this is 
> just for me to check whether 64 is not the #of threads we are starting to 
> slow down from.

I don't have results from a run handy with over 64 threads with the
patched kernel for the contended case.  But from what I've seen, the
closer the number of test threads is to the number of actual cores,
not SMT threads, the more noisy the test gets.  I think this is
reasonable/expected and that there's nothing magic about 63 or 64
threads.

We've been having network issues in the lab where this big box is.
If/when I can get access long enough, I'll do a series of runs including
past 64threads give averaged results and deviations.

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
