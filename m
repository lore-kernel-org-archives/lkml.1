Return-Path: <linux-kernel-owner+w=401wt.eu-S1751680AbZG3RLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbZG3RLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZG3RLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:11:30 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:43048
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751149AbZG3RL3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:11:29 -0400
X-SpamScore: -25
X-BigFish: VPS-25(zz1432R98dN1447Rzz1202hzzz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNLUEK-02-LSG-02
X-M-MSG: 
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Warning during suspend with MS-7310 mainboard
Date: Thu, 30 Jul 2009 12:11:12 -0500
Message-ID: <6453C3CB8E2B3646B0D020C11261327303620A02@sausexmb4.amd.com>
In-Reply-To: <20090730164629.GC2593@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Warning during suspend with MS-7310 mainboard
thread-index: AcoRNVILUi/YIv/eRHe4xd7Sa4SntQAA1V6A
References: <1248936650.3313.6.camel@queen> <1248949671.3313.10.camel@queen> <20090730154734.GB2593@redhat.com> <6453C3CB8E2B3646B0D020C11261327303620A01@sausexmb4.amd.com> <20090730164629.GC2593@redhat.com>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Dave Jones" <davej@redhat.com>
CC: "Eric Sesterhenn" <eric.sesterhenn@lsexperts.de>,
       <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
       <rusty@rustcorp.com.au>
X-OriginalArrivalTime: 30 Jul 2009 17:11:12.0870 (UTC) FILETIME=[BD817860:01CA1138]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jul 30, 2009 at 11:38:22AM -0500, Langsdorf, Mark wrote:
>  > I'll look into it.
>  > 
>  > First time I've had this bug reported, though.
>  > 
> 
> It's happening because the suspend code runs with interrupts disabled,
> and the powerpc workaround we do in the cpufreq suspend hook
> calls the drivers ->get method.
> 
> powernow-k8's ->get does an smp_call_function_single
> which needs interrupts enabled
> 
> If we just make the suspend code conditional on ppc, this 
> whole problem goes away.

Oh, thanks for the clarification.

-Mark Langsdorf
Operating System Research Center
AMD

