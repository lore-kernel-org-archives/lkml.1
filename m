Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672Ab0ALRAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab0ALRAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 12:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645Ab0ALRAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 12:00:05 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:53598 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0ALRAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 12:00:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=q6F9gKQARXbm6iiIcmGhB7OUVzfBizMddZ1YOYAWOqMBS/l/XKrgPrpX+KuT3Abr9Q
         teTOIJfAOMyDI520wo4r/kkzpCU6oJb3wI+sIaa25SWxBwFv8YL90btvvY9Xqcegj15z
         Levo1kmeyWpxRqGPikEqAoV5PoPJYcPswF3DY=
Subject: Re: [RFC] [rt-tests] change to cyclictest behavior
From: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
To: Clark Williams <williams@redhat.com>
Cc: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100106130400.7f30ae55@torg>
References: <20100106130400.7f30ae55@torg>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jan 2010 11:59:50 -0500
Message-Id: <1263315590.374.6.camel@sven.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 13:04 -0600, Clark Williams wrote:
> RT-ers,

Hi Clark,

sorry to be late to this, I have been out on a sailboat in the Bahamas.

When using the histogram feature, cyclictest already behaves the way you
describe below.

Sven

> 
> I have a problem with the way cyclictest sets up measurement threads,
> but before I went and changed things I thought I would ask if people
> cherished this particular behavior. 
> 
> Currently, when cyclictest is run with multiple threads (i.e. -t
> option) it distributes both the sample interval and the realtime
> priority by adding the 'distance' parameter to the interval and
> decrementing the priority by one. This means if you have a distance of
> 500us (default), a specified RT priority of 95 and start four threads,
> they will be started with the following parameters:
> 
> $ cyclictest -t4 -p95
> 
> Will give you:
> 
> thread		priority	sample interval
> 0		95		500
> 1		94		1000
> 2		93		1500
> 3		92		2000
> 
> What I'd like to do is modify this logic so that when '-a' (affinity) is
> specified, the priority and sample interval will not be altered. I
> don't think there's any point in distributing the priority's and
> sample intervals when the measurement threads are pinned to their own
> CPU. 
> 
> So:
> 
> $ cyclictest -t4 -p95 -a
> 
> Would have each thread at SCHED_FIFO 95 and a sample interval of 500us.
> 
> Note that this behavior also occurs when the histogram (-h) option is
> specified).
> 
> Thoughts?
> 
> Clark


