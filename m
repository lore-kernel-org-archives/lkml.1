Return-Path: <linux-kernel-owner+w=401wt.eu-S1764918AbYA2PzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764918AbYA2PzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 10:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765449AbYA2Px7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 10:53:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:52223 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765439AbYA2Px6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 10:53:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PGLDJ2PBnUYxJ5WBUuIWuWN2chjIBHbHcECSp/jUs8BshpSzR9qIfW2x5OpHjjSIRRkwsC0k2aedx4nONw8uquC09OraYCxkXdNFKK9go6AbPpe1i040h4BUg9i/WPHfVSGYBVoWaJfM5zx9cOR4JPFJnepo+tME79xPXVBF/Lg=
Message-ID: <3d8471ca0801290753j481c658bud39c541128f3f005@mail.gmail.com>
Date: Tue, 29 Jan 2008 16:53:56 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: vatsa@linux.vnet.ibm.com
Subject: Re: High wake up latencies with FAIR_USER_SCHED
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       a.p.zijlstra@chello.nl, dhaval@linux.vnet.ibm.com
In-Reply-To: <20080129054742.GA7902@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d8471ca0801271201o5a41955cg552ef06a2f821285@mail.gmail.com>
	 <20080128023129.GD1044@linux.vnet.ibm.com>
	 <3d8471ca0801280857m2ea8518ds2ad8d5346f756a0e@mail.gmail.com>
	 <3d8471ca0801281213l5ec62984i763afb22216cb423@mail.gmail.com>
	 <20080129054742.GA7902@linux.vnet.ibm.com>
X-Google-Sender-Auth: 9c50871724dc2a8a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 29, 2008 6:47 AM, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> IMHO this is expected results and if someone really needs to cut down
> this latency, they can reduce sysctl_sched_latency (which will be bad
> from perf standpoint, as we will cause more cache thrashing with that).

Thank you very much for the detailed explanation Srivatsa, that made a
lot of sense. Unfortunately, it means I'll disable FAIR_USER_SCHED as
I initially thought these latencies were caused by my local patches
that give each group a load proportional to the max load of its
elements. Anyway, I don't absolutely need a fair user scheduler on my
laptop, but low latencies in the default configuration are nice to
have.

I just thought about something to restore low latencies with
FAIR_GROUP_SCHED, but it's possibly utter nonsense, so bear with me
;-) The idea would be to reverse the trees upside down. The scheduler
would only see tasks (on the leaves) so could apply its interactivity
magic, but the hierarchical groups would be used to compute dynamic
loads for each task according to their position in the tree:

- now:
  - we schedule each level of the tree starting from the root

- with my proposition:
  - we schedule tasks like with !FAIR_GROUP_SCHED, but
calc_delta_fair() would traverse the tree starting from the leaves to
compute the dynamic load.

Thanks.

-- 
Guillaume
