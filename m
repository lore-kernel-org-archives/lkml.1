Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbZKTA5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbZKTA5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 19:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbZKTA5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 19:57:42 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:22818 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbZKTA5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 19:57:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ud+e8H6Ct+vld04fTHGM7tK5OuOZGS4X6DbB4kPauXig1L6EApVZlY6M1Vi9hrtYFP
         s3MCX5G80H8rt2KnDH58Ts+SFbYRJ2lyiE2PHVXxOBtf8wSkjGyJLvprjvXoKlc1XiIk
         I37LCAZb4EfcG8ulp8rK28OqGCG0ys+/COfns=
Date: Fri, 20 Nov 2009 01:57:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 2/2] lockdep: Don't only check recursive read locks
	once in a sequence
Message-ID: <20091120005743.GJ4967@nowhere>
References: <1258506398-5151-1-git-send-email-fweisbec@gmail.com> <1258506398-5151-3-git-send-email-fweisbec@gmail.com> <4B03C1A7.4070305@cn.fujitsu.com> <20091119155549.GB4967@nowhere> <1258650828.3931.437.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258650828.3931.437.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 06:13:48PM +0100, Peter Zijlstra wrote:
> On Thu, 2009-11-19 at 16:55 +0100, Frederic Weisbecker wrote:
> > And btw I
> > don't understand why rwsem read locks are not considered as
> > recursive in lockdep. 
> 
> Because they're not.
> 
> rwsems are FIFO fair, so a double read can deadlock when there's a
> pending writer inbetween.
> 


Aah ok. That's the subtle thing I was missing :)

Thanks.

