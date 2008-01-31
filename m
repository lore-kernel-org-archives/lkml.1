Return-Path: <linux-kernel-owner+w=401wt.eu-S932399AbYAaL3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbYAaL3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 06:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762646AbYAaL3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 06:29:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:17343 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762490AbYAaL3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 06:29:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Rf4WDIyKQtW9rzlYbL063K9nz2Qz9o8J0X1vIZRaN59Oj6CLxsqhdvhgL144rseUpInsINVvoI8+JzzQjVk9pyDJMi+CBO8fHwOgW4TGN9fNDNHHoBnzu8ygCf4HtaTseEheucMgq3ocfPa1kAUJf/u8vwP+apfAvp+GHfQzZ68=
Message-ID: <3d8471ca0801310329o5620ac39qe3a0c39f2c0baa49@mail.gmail.com>
Date: Thu, 31 Jan 2008 12:29:36 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: Hang in work_resched
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1201769710.28547.248.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d8471ca0801291430n68c0a845u1b24a590df8360f4@mail.gmail.com>
	 <3d8471ca0801301454l56dd8607g25aad3ac3cd88e75@mail.gmail.com>
	 <1201769710.28547.248.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 31, 2008 9:55 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Does this patch from thomas fix it as well?

Unfortunately, not.

For information, reverting just the first part of the offending commit
(sl->timer.cb_mode) fixed the problem, while reverting only the second
part (if (!hrtimer_active(&t->timer))) had no effect.

Also, I found a trivially reproductible testcase : sleep 0.

It hangs in nanosleep({0, 0}).

-- 
Guillaume
