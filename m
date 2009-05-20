Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbZETWG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbZETWG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 18:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755584AbZETWGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 18:06:41 -0400
Received: from claw.goop.org ([74.207.240.146]:41109 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390AbZETWGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 18:06:40 -0400
Message-ID: <4A147EEC.4000807@goop.org>
Date: Wed, 20 May 2009 15:06:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v2][PATCH 00/35] consolidate pte mapping functions across
 all architectures
References: <20090520182445.D7B49A7C@kernel>
In-Reply-To: <20090520182445.D7B49A7C@kernel>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> The steps are as follows, and should be bisectable:
> 1. Break out all the functions into a new asm/ptemap.h and
>    include it in place of the original functions.
> 2. Move linux/mm.h arch-independent pte mapping code to
>    linux/ptemap.h, include asm/ptemap.h there
> 3. Include linux/ptemap.h directly at all use sites
>    (only 39 of these kernel-wide)
> 4. Standardize all the implementations to use
>    pte_offset_kernel() as the basis for pte_offset_map()
>    whenever possible.
> 5. Create asm-generic/ptemap.h and consolidate all the
>    architectures that share the pte_offset_kernel()
>    implementations.
> 6. Consolidate the three HIGHPTE implementations (x86,
>    frv, ppc64) in asm-generic/ptemap.h.  
> 7. Remove the direct asm/ptemap.h includes.
>   

This is a nice cleanup.  Did you consider going an extra step and 
converting all the macros into #defines?

    J
