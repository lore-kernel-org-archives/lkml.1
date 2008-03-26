Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbYCZPoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbYCZPoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYCZPn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:43:59 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52469 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753357AbYCZPn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:43:58 -0400
Message-ID: <47EA6F39.6020909@sgi.com>
Date: Wed, 26 Mar 2008 08:43:53 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       "William L. Irwin" <wli@holomorphy.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 02/10] init: move setup of nr_cpu_ids to as early as	possible
 v2
References: <20080325220650.835342000@polaris-admin.engr.sgi.com> <20080325220651.146336000@polaris-admin.engr.sgi.com> <20080326062725.GD18301@elte.hu>
In-Reply-To: <20080326062725.GD18301@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Move the setting of nr_cpu_ids from sched_init() to 
>> setup_per_cpu_areas(), so that it's available as early as possible.
> 
> hm, why not a separate call before setup_per_cpu_areas(), so that we can 
> avoid spreading this from generic kernel into a bunch of architectures 
> that happen to have their own version of setup_per_cpu_areas():
> 
>>  7 files changed, 43 insertions(+), 15 deletions(-)
> 
> 	Ingo

I had this before but I then discovered that an arch would increase
(and possible decrease) it's number of possible cpus in setup_per_cpu_areas().
So I figured that setting nr_cpu_ids (and the cpumask_of_cpu map) should
be a side effect of setup_per_cpu_areas().

Thanks,
Mike
