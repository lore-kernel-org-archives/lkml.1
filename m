Return-Path: <linux-kernel-owner+w=401wt.eu-S1761303AbYA1Q57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761303AbYA1Q57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYA1Q5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:57:52 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:2503 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbYA1Q5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:57:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nY67tiwov0OoHgzAQC2gWAI/mfeCXe+sk0fbWLhFxYFW2dzN5+M5zuqK6Q0R+iJ9lUmCA0EU58jMTNs921qsDJU4uc4IV6rXXYIb+gfVx0A9A28vIx2345Ra217raDHXeHvp0sAyytvOHUHIoNdyN4OgyMHI4YiqgWLNHGUEgFw=
Message-ID: <3d8471ca0801280857m2ea8518ds2ad8d5346f756a0e@mail.gmail.com>
Date: Mon, 28 Jan 2008 17:57:49 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: vatsa@linux.vnet.ibm.com
Subject: Re: High wake up latencies with FAIR_USER_SCHED
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       a.p.zijlstra@chello.nl, dhaval@linux.vnet.ibm.com
In-Reply-To: <20080128023129.GD1044@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d8471ca0801271201o5a41955cg552ef06a2f821285@mail.gmail.com>
	 <20080128023129.GD1044@linux.vnet.ibm.com>
X-Google-Sender-Auth: 9a076e68b71f2766
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srivatsa,

On Jan 28, 2008 3:31 AM, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> Given that sysctl_sched_wakeup_granularity is set to 10ms by default,
> this doesn't sound abnormal.

Indeed, by lowering sched_wakeup_granularity I get much better
latencies, but lowering sched_latency seems to be more effective.

> NEW_FAIR_SLEEPERS feature gives credit for sleeping only to tasks and
> not group-level entities. With the patch attached, I could see that wakeup
> latencies with FAIR_USER_SCHED are restored to the same level as
> !FAIR_USER_SCHED.

Thanks for the patch, it works perfectly.

> However I am not sure whether that is the way to go. We want to let one group of
> tasks running as much as possible until the fairness/wakeup-latency threshold is
> exceeded. If someone does want better wakeup latencies between groups too, they
> can always tune sysctl_sched_wakeup_granularity.

Having an inconsistency here between FAIR_USER_SCHED and
!FAIR_USER_SCHED sounds strange, but Ingo took the patch, so I'm happy
:-)

Thanks for the replies.

-- 
Guillaume
