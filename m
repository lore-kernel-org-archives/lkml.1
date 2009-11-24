Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbZKXIAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbZKXIAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:00:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757860AbZKXIAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:00:03 -0500
Received: from mga10.intel.com ([192.55.52.92]:46087 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757301AbZKXIAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:00:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,275,1257148800"; 
   d="scan'208";a="516812524"
Subject: Re: [MM] Make mm counters per cpu instead of atomic
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <alpine.DEB.2.00.0911230830300.26432@router.home>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1>
	 <1258440521.11321.32.camel@localhost> <1258443101.11321.33.camel@localhost>
	 <1258450465.11321.36.camel@localhost>
	 <alpine.DEB.1.10.0911171223460.20360@V090114053VZO-1>
	 <1258966270.29789.45.camel@localhost>
	 <alpine.DEB.2.00.0911230830300.26432@router.home>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 24 Nov 2009 16:02:33 +0800
Message-Id: <1259049753.29789.49.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 08:31 -0600, Christoph Lameter wrote:
> On Mon, 23 Nov 2009, Zhang, Yanmin wrote:
> 
> > Another theoretic issue is below scenario:
> > Process A get the read lock on cpu 0 and is scheduled to cpu 2 to unlock. Then
> > it's scheduled back to cpu 0 to repeat the step. eventually, the reader counter
> > will overflow. Considering multiple thread cases, it might be faster to
> > overflow than what we imagine. When it overflows, processes will hang there.
> 
> True.... We need to find some alternative to per cpu data to scale mmap
> sem then.
I ran lots of benchmarks such like specjbb2005/hackbench/tbench/dbench/iozone
/sysbench_oltp(mysql)/aim7 against percpu tree(based on 2.6.32-rc7) on a 4*8*2 logical
cpu machine, and didn't find big result difference between with your patch and without
your patch.



