Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbYKFPEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbYKFPEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbYKFPEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:04:36 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:55083 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYKFPEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:04:35 -0500
Date: Thu, 6 Nov 2008 09:03:10 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Frank Mayhar <fmayhar@google.com>, Doug Chapman <doug.chapman@hp.com>,
       mingo@elte.hu, roland@redhat.com, adobriyan@gmail.com,
       akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
In-Reply-To: <1225969420.7803.4366.camel@twins>
Message-ID: <Pine.LNX.4.64.0811060900450.3595@quilx.com>
References: <1224694989.8431.23.camel@oberon>  <1225132746.14792.13.camel@bobble.smo.corp.google.com>
  <1225219114.24204.37.camel@oberon>  <1225936715.27507.44.camel@bobble.smo.corp.google.com>
 <1225969420.7803.4366.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008, Peter Zijlstra wrote:

> Also, you just introduced per-cpu allocations for each thread-group,
> while Christoph is reworking the per-cpu allocator, with one unfortunate
> side-effect - its going to have a limited size pool. Therefore this will
> limit the number of thread-groups we can have.

Patches exist that implement a dynamically growable percpu pool (using
virtual mappings though). If the cost of the additional complexity /
overhead is justifiable then we can make the percpu pool dynamically
extendable.

