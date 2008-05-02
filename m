Return-Path: <linux-kernel-owner+w=401wt.eu-S1763211AbYEBLLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763211AbYEBLLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 07:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934250AbYEBLKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 07:10:39 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:16680 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765920AbYEBLKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 07:10:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QVNIbK3krpygsd6MLhUFqoMzvJJrKkjDCjsPokhUc7XpIc96gqT+76S3XjS8Clv9+LLu3ArF0HsTSPcBZP/7s0M3vFl8BvqplDcKlKN/NiJozMQAsjFrAnVuds/5dL/xO/qUUPHSodoyhWKM+Jb3e6C3c+Ra1jXECbmiPABvCCU=
Message-ID: <82e4877d0805020410u78c6f03fr8e8e53d5a19f6846@mail.gmail.com>
Date: Fri, 2 May 2008 07:10:37 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: Horrendous Audio Stutter - current git
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Frans Pop" <elendil@planet.nl>, "Mike Galbraith" <efault@gmx.de>
In-Reply-To: <1209717278.13978.136.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com>
	 <1209717278.13978.136.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2008 at 4:34 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2008-05-01 at 20:14 -0400, Parag Warudkar wrote:

>
>  Parag, would you also test with !NEW_FAIR_SLEEPERS to see if that solves
>  your problem?
>
>  The easiest way to disable it is (assumes you have debugfs mounted
>  at /debug):
>
>   # echo NO_NEW_FAIR_SLEEPERS > /debug/sched_features

Seems to make it stutter a little less - but still not usable.

>
>  You can also disable NORMALIZED_SLEEPER that way (of course you would
>  first have to enable NEW_FAIR_SLEEPERS again):
>
>   # echo NO_NORMALIZED_SLEEPER > /debug/sched_features
>
No significant difference from NO_NEW_FAIR_SLEEPERS that I can tell.

>  So by default we have both enabled; could you report if either
>
>  NO_NEW_FAIR_SLEEPERS
>
>  NEW_FAIR_SLEEPERS + NO_NORMALIZED_SLEEPERS
>
>  works for you?

I would say no - the audio still is unusable - slightly better with
NO_NEW_FAIR_SLEEPERS, no difference with the other.

But per Mike's suggestion if I disable CONFIG_GROUP_SCHED ,
CONFIG_FAIR_GROUP_SCHED and CONFIG_USER_SCHED, even with
NEW_FAIR_SLEEPERS audio is good again, which does not change with
NO_NEW_FAIR_SLEEPERS. (No skips for long time under -j8 - still skips
a _very_ tiny bit - noticeable if I listen too carefully - but we can
ignore that for the time being.)

Mike -  the GROUP_SCHED stuff is set to y in the Ubuntu kernel and I
have no audio skips - may be a regression introduced after 2.6.24?

But why is the GROUP_SCHED stuff default y if it so unusable?

>
>  Also, could you apply this patch, and report the bonus_max value for
>  your music player under all three scenarios?
>

I see Frans already reported that and there was some conclusion - let
me know if more data will help.

Thanks!

Parag
