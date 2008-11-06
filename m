Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbYKFPIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbYKFPIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYKFPH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:07:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:52528 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYKFPH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:07:58 -0500
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Frank Mayhar <fmayhar@google.com>, Doug Chapman <doug.chapman@hp.com>,
       mingo@elte.hu, roland@redhat.com, adobriyan@gmail.com,
       akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0811060900450.3595@quilx.com>
References: <1224694989.8431.23.camel@oberon>
	 <1225132746.14792.13.camel@bobble.smo.corp.google.com>
	 <1225219114.24204.37.camel@oberon>
	 <1225936715.27507.44.camel@bobble.smo.corp.google.com>
	 <1225969420.7803.4366.camel@twins>
	 <Pine.LNX.4.64.0811060900450.3595@quilx.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Nov 2008 16:08:18 +0100
Message-Id: <1225984098.7803.4642.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-06 at 09:03 -0600, Christoph Lameter wrote:
> On Thu, 6 Nov 2008, Peter Zijlstra wrote:
> 
> > Also, you just introduced per-cpu allocations for each thread-group,
> > while Christoph is reworking the per-cpu allocator, with one unfortunate
> > side-effect - its going to have a limited size pool. Therefore this will
> > limit the number of thread-groups we can have.
> 
> Patches exist that implement a dynamically growable percpu pool (using
> virtual mappings though). If the cost of the additional complexity /
> overhead is justifiable then we can make the percpu pool dynamically
> extendable.

Right, but I don't think the patch under consideration will fly anyway,
doing a for_each_possible_cpu() loop on every tick on all cpus isn't
really healthy, even for moderate sized machines.
