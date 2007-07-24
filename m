Return-Path: <linux-kernel-owner+w=401wt.eu-S933105AbXGXU6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105AbXGXU6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933079AbXGXU6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:58:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:29057 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933066AbXGXU6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:58:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,575,1175497200"; 
   d="scan'208";a="254253590"
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
From: "Li, Tong N" <tong.n.li@intel.com>
To: Chris Snook <csnook@redhat.com>
Cc: Chris Friesen <cfriesen@nortel.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <46A66393.5000705@redhat.com>
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com>
	 <46A53C88.6060006@redhat.com>
	 <Pine.LNX.4.64.0707240954560.8026@tongli.jf.intel.com>
	 <46A64002.8080103@redhat.com> <46A6576A.9020506@nortel.com>
	 <46A66393.5000705@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 24 Jul 2007 13:58:11 -0700
Message-Id: <1185310691.7737.40.camel@tongli.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
X-OriginalArrivalTime: 24 Jul 2007 20:58:12.0330 (UTC) FILETIME=[58E464A0:01C7CE35]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 16:39 -0400, Chris Snook wrote:

> Divining the intentions of the administrator is an AI-complete problem and we're 
> not going to try to solve that in the kernel.  An intelligent administrator 
> could also allocate 50% of each CPU to a resource group containing all the 
> *other* processes.  Then, when the other processes are scheduled out, your 
> single task will run on whichever CPU is idle.  This will very quickly 
> equilibrate to the scheduling ping-pong you seem to want.  The scheduler 
> deliberately avoids this kind of migration by default because it hurts cache and 
> TLB performance, so if you want to override this very sane default behavior, 
> you're going to have to explicitly configure it yourself.
> 

Well, the admin wouldn't specifically ask for 50% of each CPU. He would
just allocate 50% of total CPU time---it's up to the scheduler to
fulfill that. If a task is entitled to one CPU, then it'll stay there
and have no migration. Migration occurs only if there's overload, in
which case I think you agree in your last email that the cache and TLB
impact is not an issue (at least in SMP).

  tong
