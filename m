Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbZGOHuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbZGOHuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 03:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbZGOHuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 03:50:11 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:58739 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbZGOHuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 03:50:10 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC][PATCH 0/8] Use EDF to throttle RT task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <20090709135117.GR14563@gandalf.sssup.it>
References: <cover.1245092261.git.fabio@helm.retis>
	 <1247135773.9777.357.camel@twins> <20090709135117.GR14563@gandalf.sssup.it>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 09:50:12 +0200
Message-Id: <1247644212.7500.202.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 15:51 +0200, Fabio Checconi wrote:

> I was thinking about doing things gradually: first extend throttling
> to handle generic periods, then extend the push-pull logic (I think you
> are referring to it with load-balancing) to fully support it, and then
> think about global EDF.  I think it would be difficult to do all the
> things at one time.

Agreed.

> About minimal concurrency group scheduling, I am not sure of how we
> would handle CPUs hot insertion/extraction, or how the allocation would
> be done efficiently (avoiding bin-packing issues) online inside the kernel.

Right, since the current interface specifies bandwidth in a single-cpu
normalized fashion, adding/removing cpus will only affect the total
bandwidth available, but should not affect the bandwidth calculations.

So it should not break anything, but it sure might surprise, then again,
hotplug is an explicit action on behalf of the admin, so he pretty much
gets what he asked for :-)

I might have to re-read that mim-concurrency G-EDF paper again, but I
failed to spot the bin-packing issue.

> To adapt the current load-balancer to the choices of the deadline-based
> scheduler I was thinking about using a cpupri-like structure per task_group,
> but now I'm not able to estimate the resulting overhead...

Right, per task_group sounds about the right level for the FIFO
balancer. It gets a little more complicated due to having a dynamic
number of vcpus being served at any one time though.

This will also lead to extra task migrations, but sure, whatever works
first, then make it better.

> Do you think that this gradual approach makes sense?

Yeah it does ;-)

