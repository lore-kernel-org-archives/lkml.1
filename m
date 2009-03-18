Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbZCRHKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbZCRHKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 03:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZCRHJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 03:09:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33047 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbZCRHJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 03:09:59 -0400
Date: Wed, 18 Mar 2009 16:08:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: bharata@linux.vnet.ibm.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, balbir@linux.vnet.ibm.com,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip] cpuacct: Make cpuacct hierarchy walk in
 cpuacct_charge() safe when rcupreempt is used.
Message-Id: <20090318160827.fa53cb9b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090318044801.GC3960@in.ibm.com>
References: <20090317061754.GD3314@in.ibm.com>
	<49BF42FB.4030103@cn.fujitsu.com>
	<20090317073649.GH3314@in.ibm.com>
	<20090317131251.GU16897@balbir.in.ibm.com>
	<1237296361.7867.16.camel@twins>
	<20090317135938.GV16897@balbir.in.ibm.com>
	<1237298686.7867.17.camel@twins>
	<20090318032558.GB3960@in.ibm.com>
	<20090318125434.63d833e4.kamezawa.hiroyu@jp.fujitsu.com>
	<20090318044801.GC3960@in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009 10:18:01 +0530
Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
> Looks ok to me, but will wait for experts' comments.
> 
> However, I did a quick measurement of read times with percpu_counter_read()
> (no readside lock) and percpu_counter_sum() (readside lock) and I don't
> see a major slowdown with percpu_counter_sum().
> 
> Time taken for 100 reads of cpuacct.stat with 1s delay b/n every read.
> percpu_counter_read() - 9845 us
> percpu_counter_sum() - 9974 us
> 
Then, almost 1 us overhead per read().....Hmm, seems big (as counter).

Thanks,
-Kame

