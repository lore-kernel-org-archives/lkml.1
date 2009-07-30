Return-Path: <linux-kernel-owner+w=401wt.eu-S1752909AbZG3XH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbZG3XH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 19:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbZG3XH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 19:07:26 -0400
Received: from ozlabs.org ([203.10.76.45]:41321 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbZG3XH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 19:07:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Jones <davej@redhat.com>
Subject: Re: Warning during suspend with MS-7310 mainboard
Date: Fri, 31 Jul 2009 08:37:22 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; i686; ; )
Cc: "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       Eric Sesterhenn <eric.sesterhenn@lsexperts.de>,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
References: <1248936650.3313.6.camel@queen> <6453C3CB8E2B3646B0D020C11261327303620A01@sausexmb4.amd.com> <20090730164629.GC2593@redhat.com>
In-Reply-To: <20090730164629.GC2593@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907310837.23487.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009 02:16:29 am Dave Jones wrote:
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

Yeah, I was confused: my patch changed set_cpus_allowed_ptr() to
an smp_call_function.  If the latter is a bad idea with irqs disabled, the
former certainly was...

Thanks,
Rusty.
