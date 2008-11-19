Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbYKSGnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbYKSGnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 01:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYKSGni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 01:43:38 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59311 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbYKSGnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 01:43:37 -0500
X-IronPort-AV: E=McAfee;i="5300,2777,5438"; a="13287882"
Message-ID: <4923B597.7090208@qualcomm.com>
Date: Tue, 18 Nov 2008 22:43:35 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
       "csnook@redhat.com" <csnook@redhat.com>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: default IRQ affinity change in v2.6.27 (breaking several SMP
 PPC based systems)
References: <4E3CD4D5-FC1B-40BF-A776-C612B95806B8@kernel.crashing.org>	<4901E6FB.4070200@redhat.com>	<36A821E7-7F37-42AF-9A05-7205FCBF89EE@kernel.crashing.org> <20081024.161818.256978293.davem@davemloft.net>
In-Reply-To: <20081024.161818.256978293.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



David Miller wrote:
> From: Kumar Gala <galak@kernel.crashing.org>
> Date: Fri, 24 Oct 2008 10:39:05 -0500
> 
>> As for making it ARCH specific, that doesn't really help since not
>> all PPC hw has the limitation I spoke of.  Not even all MPIC (in our
>> cases) have the limitation.
> 
> Since the PPC code knows exactly which MPICs have the problem the
> PPC code is where the constraining can occur.
> 
> I agree completely with the suggestion that the arch code has to
> interpret the cpumask as appropriate for the hardware, since the
> user can stick "illegal" values there anyways.

Sorry for delay in replying to this. And sorry for causing regression on some
ppc platforms.
I totally agree with what Dave said above. ALL_CPUS is a sane default,
platform code has to sanity check masks passed via set_affinity() calls
anyway. So I beleive it should be fixed in the platform code.

Max

