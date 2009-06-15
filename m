Return-Path: <linux-kernel-owner+w=401wt.eu-S1762560AbZFOPk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762560AbZFOPk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761099AbZFOPkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:40:15 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:10936
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757416AbZFOPkO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:40:14 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz1432R1805Mzz1202hzzz32i6bh17ch43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KLAE6P-02-XU4-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] cpumask: avoid playing with cpus_allowed in powernow-k8.c
Date: Mon, 15 Jun 2009 10:40:09 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273036209AB@sausexmb4.amd.com>
In-Reply-To: <200906122055.38203.rusty@rustcorp.com.au>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] cpumask: avoid playing with cpus_allowed in powernow-k8.c
Thread-Index: AcnrUI5liU+eNxTnT3KeA1vsY1H6sgCftzFA
References: <20090611225928.E6FF4DDDA1@ozlabs.org> <20090611232517.GA32486@redhat.com> <200906122055.38203.rusty@rustcorp.com.au>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>, "Dave Jones" <davej@redhat.com>
CC: <cpufreq@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@redhat.com>
X-OriginalArrivalTime: 15 Jun 2009 15:40:10.0254 (UTC) FILETIME=[90F1AAE0:01C9EDCF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> cpumask: avoid playing with cpus_allowed in powernow-k8.c
>     
> It's generally a very bad idea to mug some process's cpumask: it could
> legitimately and reasonably be changed by root, which could break us
> (if done before our code) or them (if we restore the wrong value).
>     
> I did not replace powernowk8_target; it needs fixing, but it grabs a
> mutex (so no smp_call_function_single here) but Mark points out it can
> be called multiple times per second, so work_on_cpu is too heavy.
>     
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> To: davej@redhat.com
> To: cpufreq@vger.kernel.org
> Cc: mark.langsdorf@amd.com

I ran this over the weekend on a 24 core box without
any issues.  Please commit.

Acked-by: Mark Langsdorf <mark.langsdorf@amd.com>
Tested-by: Mark Langsdorf <mark.langsdorf@amd.com>

