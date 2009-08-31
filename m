Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbZHaJJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbZHaJJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 05:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbZHaJJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 05:09:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:49126 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbZHaJJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 05:09:41 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Guillaume Chazarain <guichaz@gmail.com>
Subject: Re: [PATCH 1/3] taskstats-fork: Add a new taskstats command to get notification on fork/clone
Date: Mon, 31 Aug 2009 14:41:28 +0530
User-Agent: KMail/1.12.0 (Linux/2.6.27.29-0.1-default; KDE/4.3.0; x86_64; ; )
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       procps-feedback@lists.sf.net, Albert Cahalan <albert@users.sf.net>
References: <200907211031.48294.knikanth@suse.de> <200907211154.42563.knikanth@suse.de> <3d8471ca0908301252j15cb33b1j913921bd8fc6704c@mail.gmail.com>
In-Reply-To: <3d8471ca0908301252j15cb33b1j913921bd8fc6704c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908311441.28354.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 August 2009 01:22:22 Guillaume Chazarain wrote:
> On Tue, Jul 21, 2009 at 8:24 AM, Nikanth Karthikesan<knikanth@suse.de> 
wrote:
> > Ah.. proc-events was the exact thing, I was looking for! Thanks.
>
> AFAICT proc-events can only be used by root, so that makes it
> unsuitable for *top.
>
> Anyway, iotop will always have to iterate over all threads to query
> their taskstats and other attributes, so the O(nr_threads) complexity
> is unavoidable.
>

If it would simply iterate over all the current threads, the complexity would 
be O(nr_threads). But while iterating through all the current threads, it 
checks whether it is a new thread or a known thread, so that it can calculate 
the delta values. This is what I optimized by using taskstats-fork, which 
could be optimized using proc-events. 

Thanks
Nikanth
