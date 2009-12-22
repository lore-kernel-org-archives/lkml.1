Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbZLVLLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbZLVLLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 06:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbZLVLLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 06:11:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:39850 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZLVLLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 06:11:35 -0500
Subject: Re: workqueue thing
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net
In-Reply-To: <4B300C01.8080904@kernel.org>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>
	 <1261143924.20899.169.camel@laptop> <20091218135033.GB8678@basil.fritz.box>
	 <4B2B9949.1000608@linux.intel.com> <20091221091754.GG4489@kernel.dk>
	 <4B2F57E6.7020504@linux.intel.com> <4B2F768C.1040704@kernel.org>
	 <4B2F7DD2.2080902@linux.intel.com> <4B2F83F6.2040705@kernel.org>
	 <4B2F9212.3000407@linux.intel.com>  <4B300C01.8080904@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 12:10:20 +0100
Message-ID: <1261480220.4937.24.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-22 at 09:00 +0900, Tejun Heo wrote:
> 
> Yeah, sure, it's not suited for offloading CPU intensive workloads
> (checksumming and encryption basically).  Workqueue interface was
> never meant to be used by them - it has strong cpu affinity.  We need
> something which is more parallelism aware for those. 

Right, so what about cleaning that up first, then looking how many
workqueues can be removed by converting to threaded interrupts and then
maybe look again at some of your async things?

As to the SCSI/ATA error, have to wait for a year on hardware threads,
why not simply use the existing work to create a one-time (non-affine)
thread for that? Its not like it'll ever happen much.

