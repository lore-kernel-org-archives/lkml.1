Return-Path: <linux-kernel-owner+w=401wt.eu-S1757167AbZEKP6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbZEKP6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZEKP6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:58:36 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:22410 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZEKP6f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:58:35 -0400
X-BigFish: VPS-13(zba6lz1432R1805MaccKzz1202hzzz32i6bh66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KJHLP5-01-DUO-01
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH][KVM][retry 1] Add support for Pause Filtering to AMDSVM
Date: Mon, 11 May 2009 10:58:24 -0500
Message-ID: <6453C3CB8E2B3646B0D020C1126132730362094C@sausexmb4.amd.com>
In-Reply-To: <20090511145903.GB737@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH][KVM][retry 1] Add support for Pause Filtering to AMDSVM
Thread-Index: AcnSSRqnvx6G+BR2Tc+1dtlXGPw74gABYFoQ
References: <200905050909.58583.mark.langsdorf@amd.com> <20090507135522.GJ4059@amd.com> <200905071000.14038.mark.langsdorf@amd.com> <4A02FECC.6060609@redhat.com> <20090511141503.GC6175@elte.hu> <4A083539.407@redhat.com> <20090511143320.GE6175@elte.hu> <4A083B69.6010702@redhat.com> <20090511145903.GB737@elte.hu>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Avi Kivity" <avi@redhat.com>
CC: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Roedel, Joerg" <Joerg.Roedel@amd.com>, <kvm@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 May 2009 15:58:24.0992 (UTC) FILETIME=[51002E00:01C9D251]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Please dont even think about using yield for this though - 

Oops.  I'm glad I waited to get some benchmark results before
submitting that version.

> >> A gradual and linear back-off from the current timeline is 
> >> more of a fair negotiation process between vcpus and
> >> results in more or less  
> >> sane (and fair) scheduling, and no unnecessary looping.
> >>
> >> You could even do an exponential backoff up to a limit of 
> >> 1-10 msecs or so, starting at 100 usecs.
> >
> > Good idea, it eliminates another variable to be tuned.
> 
> It could be made fully self-tuning, if the filter threshold can be 
> tuned fast enough. (an MSR write? A VM context field update?)

VMCB field update.

So the suggestion is to add a function similar to set_task_cpu()
that increases the vmruntime with an exponential backoff?  Is
that sufficient to cause a new VCPU to step in?  I'm obviously
not very familiar with the scheduler code.
 
> I.e. the 3000 cycles value itself could be eliminated as well. (with 
> just a common-sense max of say 100,000 cycles enforced)

I don't understand what you're saying here.  There needs to be
some value in the pause filter counter to trigger the intercept.

-Mark Langsdorf
Operating System Research Center
AMD

