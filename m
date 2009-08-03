Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbZHCGet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbZHCGet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 02:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZHCGet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 02:34:49 -0400
Received: from ozlabs.org ([203.10.76.45]:40419 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbZHCGes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 02:34:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Jones <davej@redhat.com>
Subject: Re: Warning during suspend with MS-7310 mainboard
Date: Mon, 3 Aug 2009 16:04:41 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; i686; ; )
Cc: "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       Eric Sesterhenn <eric.sesterhenn@lsexperts.de>,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
References: <1248936650.3313.6.camel@queen> <200907310837.23487.rusty@rustcorp.com.au> <20090730231702.GA15520@redhat.com>
In-Reply-To: <20090730231702.GA15520@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908031604.42857.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009 08:47:02 am Dave Jones wrote:
> On Fri, Jul 31, 2009 at 08:37:22AM +0930, Rusty Russell wrote:
>  > Yeah, I was confused: my patch changed set_cpus_allowed_ptr() to
>  > an smp_call_function.  If the latter is a bad idea with irqs disabled, the
>  > former certainly was...
> 
> Right, the only reason reverting your change 'fixes' the problem is
> that we don't have a BUG() in set_cpus_allowed_ptr to check for interrupts
> being disabled.

Exactly.

> hmm, does adding an equivalent check make sense?
> cpufreq seemed to cope just fine when we used set_cpus_allowed_ptr,
> but we might have just got lucky. As we were suspending in this path,
> interaction from the scheduler is minimal. Other callers might not
> be so lucky?

If someone who knows the code can verify that, in fact, we are always on the
right CPU, we can eliminate it altogether.

I'm not happy with a "probably get lucky" scenario...
Rusty.
