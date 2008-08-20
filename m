Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbYHTNIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbYHTNIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 09:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbYHTNIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 09:08:14 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:29356 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbYHTNIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 09:08:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s3xNsA/gG6YDNR945EDKuIFmnSLts97LlR0VSzpXVJhY8EJkSoHHQZUGyn3PKj3nfE
         uGFeET5SBQ/Ud9O4koSadPKSgFFzT3xgkL4XKdYg8PGperNuYROBpGpypZ2KjGsQOLi1
         GKUtuXN+2mwycmiEOy+iHXPX1mnNhvwvVwnzo=
Date: Wed, 20 Aug 2008 09:08:06 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org, menage@google.com,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [input layer, lockdep warning] Re: [PATCH] cpuset: Rework
	sched domains and CPU hotplug handling (take 4)
Message-ID: <20080820090454.ZZRA012@mailhub.coreip.homeip.net>
References: <1218490433-10576-1-git-send-email-maxk@qualcomm.com> <20080811183122.acd25489.pj@sgi.com> <20080814092424.GB18771@elte.hu> <20080814111633.GA2614@elte.hu> <48A477B8.9090704@qualcomm.com> <20080820064437.GA14208@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820064437.GA14208@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 08:44:37AM +0200, Ingo Molnar wrote:
> 
> Dmitry,
> 
> this lockdep warning triggered again in -tip testing:
> 
> > > [   59.750200] =======================================================
> > > [   59.750200] [ INFO: possible circular locking dependency detected ]
> > > [   59.750200] 2.6.27-rc3-tip-00076-g75f9a29-dirty #1
> > > [   59.750200] -------------------------------------------------------
> > > [   59.750200] Xorg/6623 is trying to acquire lock:
> > > [   59.750200]  (cpu_add_remove_lock){--..}, at: [<c0147dae>] cpu_maps_update_begin+0x14/0x16
> > > [   59.750200] 
> > > [   59.750200] but task is already holding lock:
> > > [   59.750200]  (polldev_mutex){--..}, at: [<c07eb66f>] input_close_polled_device+0x22/0x47
> > > [   59.750200] 
> > > [   59.750200] which lock already depends on the new lock.
> 
> See the bootlog below. Upstream base of the tree below is 
> 1fca254274823876. The first warnings came with b635acec48.
> 

Ingo,

I am not quite sure why lockdep complains. From the input POV
everything is pretty simple - we use polldev_mutex to start ipolldevd
workqueue on demand, when first user appears, and also to destroy
workqueue after last iser is gone.

Is it reporoducible for you? Is it only with your tree or mainline as
well?

-- 
Dmitry
