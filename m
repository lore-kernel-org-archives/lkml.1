Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbZFNJ4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbZFNJ4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 05:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZFNJ4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 05:56:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:53983 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbZFNJ4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 05:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=ItjFGfQCa4F3tV09KGDuOaYGT0SJdbDCr7VjjQphCOoUsNBhjlHK3/eDHkAh+9OdwR
         nyAYieNoJNn52d0Zl7Wvf77cY41l9/hzjW81TBmy3d1xeq+1661MBFr8x27FH0QG4zj5
         CGevFr4L0EmBIJcO4auVS28bCii9JQYxj07Gg=
MIME-Version: 1.0
In-Reply-To: <20090614093725.GD832@linux-sh.org>
References: <1244806169-12232-1-git-send-email-vapier@gentoo.org> 
	<8bd0f97a0906130348p474faf57yeb729aa07059c599@mail.gmail.com> 
	<20090614093725.GD832@linux-sh.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 14 Jun 2009 05:55:44 -0400
Message-ID: <8bd0f97a0906140255h295b393dl3165fff4c0a6baf6@mail.gmail.com>
Subject: Re: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open 
	when supported
To: Paul Mundt <lethal@linux-sh.org>, akpm <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 05:37, Paul Mundt wrote:
> On Sat, Jun 13, 2009 at 06:48:52AM -0400, Mike Frysinger wrote:
>> On Fri, Jun 12, 2009 at 07:29, Mike Frysinger wrote:
>> > If the port does not support HAVE_PERF_COUNTERS, then they can't support
>> > the perf_counter_open syscall either. ??Rather than forcing everyone to add
>> > an ignore (or suffer the warning until they get around to implementing
>> > support), only whine about the syscall when applicable.
>> >
>> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>>
>> Andrew: could you pick this up since Ingo acked it now ?

btw, Sam said he would pick it up via the kbuild tree

> I fail to see why this is necessary? cond_syscall() takes care of this in
> the not implemented case, the same as every other syscall backing some
> feature that has yet to be implemented.

i dont think we should go hassling every arch maintainer when a new
syscall is added that requires arch-specific support for optional
features (especially when said features are debug in nature).  if
wiring up the syscall is the only work because the code is all common
(like the pread/pwrite functions), then np of course.
-mike
