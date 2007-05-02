Return-Path: <linux-kernel-owner+w=401wt.eu-S1767211AbXEBSzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767211AbXEBSzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767237AbXEBSzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:55:42 -0400
Received: from holomorphy.com ([66.93.40.71]:44915 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767211AbXEBSzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:55:40 -0400
Date: Wed, 2 May 2007 11:56:13 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ting Yang <tingy@cs.umass.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070502185613.GU31925@holomorphy.com>
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu> <20070502173634.GA11308@in.ibm.com> <20070502174829.GX19966@holomorphy.com> <20070502181533.GA19479@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502181533.GA19479@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* William Lee Irwin III <wli@holomorphy.com> wrote:
>> Virtual time is time from the task's point of view, which it has spent 
>> executing. ->wait_runtime is a device to subtract out time spent on 
>> the runqueue but not running from what would otherwise be virtual time 
>> to express lag, whether deliberately or coincidentally. [...]

On Wed, May 02, 2007 at 08:15:33PM +0200, Ingo Molnar wrote:
> CFS is in fact _built around_ the ->wait_runtime metric (which, as its 
> name suggests already, expresses the precise lag a task observes 
> relative to 'ideal' fair execution), so what exactly makes you suspect 
> that this property of the ->wait_runtime metric might be 'coincidental'? 
> ;-)

The coincidental aspect would be that at the time it was written, the
formal notion of lag was not being used particularly with respect to
priorities and load weights. The documentation doesn't describe it in
those terms, and I can't read minds, so I refrained from guessing.

Things are moving in good directions on all this as far as I'm
concerned. Moving according to Ting Yang's analysis should wrap up the
soundness concerns about intra-queue policy I've had. OTOH load
balancing I know much less about (not that I was ever any sort of an
expert on single queue affairs). That remains a very deep concern, as
load balancing is where most of the enterprise performance improvements
and degradations occur.


-- wli
