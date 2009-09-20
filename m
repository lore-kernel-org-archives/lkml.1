Return-Path: <linux-kernel-owner+w=401wt.eu-S1751487AbZITVDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbZITVDi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 17:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbZITVDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 17:03:35 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:11921
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750868AbZITVDe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 17:03:34 -0400
X-SpamScore: -2
X-BigFish: VPS-2(z5c5oz1432Rzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KQAFTN-02-FS8-02
X-M-MSG: 
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "'Avi Kivity'" <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 20 Sep 2009 16:03:23 -0500
Subject: RE: [PATCH] Prevent immediate process rescheduling
Thread-Topic: [PATCH] Prevent immediate process rescheduling
Thread-Index: Aco5A6enSyB16uYiSJmABVb0g72NugBMe/cg
Message-ID: <DDE95BDD51FB774B804A9C029E735EE10379BEDA2F@sausexmbp02.amd.com>
References: <200909181449.12311.mark.langsdorf@amd.com>
	 <20090918195455.GC11726@elte.hu> <1253304203.10538.64.camel@laptop>
 <4AB496ED.7010800@redhat.com>
In-Reply-To: <4AB496ED.7010800@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Really hate this change though,. doesn't seem right to not 
> pick the same
> > task again if its runnable. Bad for cache footprint.
> 
> I agree, yielding should be explicitly requested.
> 
> Also, on a heavily overcommitted box an undirected yield might take 
> quite a long time to find the thread that's holding the lock. 
>  I think a 
> yield_to() will be a lot better:
> 
> - we can pick one of the vcpus belonging to the same guest to improve 
> the probability that the lock actually get released

Is there a way to find the other vcpus belonging to the
same guest?  I poked around at that, but couldn't find
one.

> - we avoid an issue when the other vcpus are on different 
> runqueues (in which case the current patch does nothing)
> - we can fix the accounting by donating vruntime from current to the 
> yielded-to vcpu

I may need someone to walk me through the vruntime donation
but that's secondary to finding the other vcpus.

-Mark Langsdorf
Operating System Research Center
AMD
