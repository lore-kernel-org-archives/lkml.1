Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbZIJWQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbZIJWQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 18:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbZIJWQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 18:16:58 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:56917 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbZIJWQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 18:16:58 -0400
Subject: Re: [PATCH] update clocksource raw_time in timekeeping_suspend
From: john stultz <johnstul@us.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: ye janboe <janboe.ye@gmail.com>, zippel@linux-m68k.org,
       akpm@linux-foundation.org, mingo@elte.hu,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <2674af740909100231x582851dbv9b71bc2914be7030@mail.gmail.com>
References: <af3ea28a0909090035t710f5895i135760a2c7bd8a02@mail.gmail.com>
	 <1252537622.9883.24.camel@localhost.localdomain>
	 <af3ea28a0909100107q328d1288x8d677d4d5f79f728@mail.gmail.com>
	 <2674af740909100231x582851dbv9b71bc2914be7030@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 15:15:38 -0700
Message-Id: <1252620938.7319.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 17:31 +0800, Yong Zhang wrote:
> On Thu, Sep 10, 2009 at 4:07 PM, ye janboe <janboe.ye@gmail.com> wrote:
> > hi, John
> >
> > Thanks for your comments.
> >
> > After sent this patch, I realize that this patch exposes the hardware
> > detail ugly in common code.
> >
> > In embed system, user space apps need to have a method to get the
> > right time which will not be impacted by NTP and suspend.
> >
> > Yes, you are right. I want to add sleep_length to the raw time and
> > user space apps could get the right time after suspend.
> >
> 
> What I get from the code is that CLOCK_MONOTONIC doesn't consider
> sleep_length either. Do I miss something?

You're quite right. I forgot we drop sleep_length from
wall_to_monotonic, so it should not increase while we're suspended.

Janboe: So I think things are fine as they stand. No patch necessary.

But please let me know if I'm yet again forgetting something or you're
finding CLOCK_MONOTONIC_RAW to be insufficient in some way.

thanks
-john

