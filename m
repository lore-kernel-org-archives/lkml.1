Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbZCRIFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbZCRIFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 04:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbZCRIFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 04:05:39 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:55424 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbZCRIFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 04:05:37 -0400
Date: Wed, 18 Mar 2009 13:35:39 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, balbir@linux.vnet.ibm.com,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip] cpuacct: Make cpuacct hierarchy walk in
	cpuacct_charge() safe when rcupreempt is used.
Message-ID: <20090318080539.GD3960@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <49BF42FB.4030103@cn.fujitsu.com> <20090317073649.GH3314@in.ibm.com> <20090317131251.GU16897@balbir.in.ibm.com> <1237296361.7867.16.camel@twins> <20090317135938.GV16897@balbir.in.ibm.com> <1237298686.7867.17.camel@twins> <20090318032558.GB3960@in.ibm.com> <20090318125434.63d833e4.kamezawa.hiroyu@jp.fujitsu.com> <20090318044801.GC3960@in.ibm.com> <20090318160827.fa53cb9b.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090318160827.fa53cb9b.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 04:08:27PM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 18 Mar 2009 10:18:01 +0530
> Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
> > Looks ok to me, but will wait for experts' comments.
> > 
> > However, I did a quick measurement of read times with percpu_counter_read()
> > (no readside lock) and percpu_counter_sum() (readside lock) and I don't
> > see a major slowdown with percpu_counter_sum().
> > 
> > Time taken for 100 reads of cpuacct.stat with 1s delay b/n every read.
> > percpu_counter_read() - 9845 us
> > percpu_counter_sum() - 9974 us
> > 
> Then, almost 1 us overhead per read().....Hmm, seems big (as counter).

Well some cost for correct and accurate counter :)

BTW, I did a few more iterations and I don't see consistent numbers.
The results from 7 runs look like this:

percpu_counter_read() - 11325, 11549, 5939, 9999, 7129, 7758, 11385 us
percpu_counter_sum() - 8655, 9201, 8705, 11766, 10619, 9186, 8890 us 

Regards,
Bharata.
