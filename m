Return-Path: <linux-kernel-owner+w=401wt.eu-S1757072AbZBKPFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbZBKPFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 10:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbZBKPFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 10:05:33 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:19379 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbZBKPFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:05:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=YKcS2sif34TPcdW+BAi5iVh+mKgUvI9Ys98Je3vgOKTGTEGe9qFSR1Vrk2oD1Da/eo
         WVODKWvNki8Y5U9OufHB1f5y+WLk3RP3YdDiy5tMJjYIiEZJtAfc2IQAqHItVDKTMXPZ
         LBVtzPo+2huWwrRl26aJXWdOTzekwqczOo5ag=
Message-ID: <4992E92C.5000000@gmail.com>
Date: Thu, 12 Feb 2009 00:05:16 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Pass in pt_regs pointer for syscalls that need
 	it
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com>	 <1234277507-4987-3-git-send-email-brgerst@gmail.com>	 <4992812B.1050800@kernel.org>	 <73c1f2160902110631j68e58202h3e49288cfe613d66@mail.gmail.com>	 <4992E396.6000205@kernel.org> <4992E551.4060901@gmail.com> <73c1f2160902110659i776e1d89qc23d89363881572e@mail.gmail.com>
In-Reply-To: <73c1f2160902110659i776e1d89qc23d89363881572e@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> On Wed, Feb 11, 2009 at 9:48 AM, Tejun Heo <htejun@gmail.com> wrote:
>> Tejun Heo wrote:
>>>> I checked the disassembly of these functions and didn't see this
>>>> happen on gcc 4.3.0.
>>> Well, tracking down why run_init_process() is returning 0 with
>>> -fstack-protector wasn't much of fun.  These breakages are very subtle
>>> and if we're gonna pass in pointer to pt_regs anyway and thus can
>>> guarantee such breakage can't happen at no additional cost, I think we
>>> should do that even if it means slightly more argument fetching in a
>>> few places.
>> In addition, if we do that, we can remove the horrible
>> asmlinkage_protect() thing altogether.
> 
> Like I said before, the tail-call optimization problem isn't limited
> to just this set of syscalls.  There are only two real ways to fix it.
> 1) Set up a real stack frame for the syscalls instead of overalying
> pt_regs, or 2) patch gcc to tell it not to touch the args area of the
> stack.

Right, I forgot about the generic ones.  We can pass pointer to
pt_regs to all of them like x86_64 does but yeah we're likely to lose
more than we gain by doing that.  :-(

-- 
tejun
