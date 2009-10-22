Return-Path: <linux-kernel-owner+w=401wt.eu-S932093AbZJVVEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbZJVVEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 17:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbZJVVEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 17:04:37 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46379 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951AbZJVVEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 17:04:36 -0400
Subject: Re: [PATCH] BUILD_BUG_ON: make it handle more cases
From: Hollis Blanchard <hollisb@us.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jan Beulich <JBeulich@novell.com>, sfr@canb.auug.org.au,
       akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
       kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
In-Reply-To: <200910201415.34361.rusty@rustcorp.com.au>
References: <4AC1E15502000078000516B5@vpn.id2.novell.com>
	 <200910201142.34006.rusty@rustcorp.com.au> <1256002193.6546.2.camel@slab>
	 <200910201415.34361.rusty@rustcorp.com.au>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Thu, 22 Oct 2009 14:04:37 -0700
Message-Id: <1256245477.7495.30.camel@slab.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-20 at 14:15 +1030, Rusty Russell wrote:
> BUILD_BUG_ON used to use the optimizer to do code elimination or fail
> at link time; it was changed to first the size of a negative array (a
> nicer compile time error), then (in
> 8c87df457cb58fe75b9b893007917cf8095660a0) to a bitfield.
> 
> bitfields: needs a literal constant at parse time, and can't be put under
> 	"if (__builtin_constant_p(x))" for example.
> negative array: can handle anything, but if the compiler can't tell it's
> 	a constant, silently has no effect.
> link time: breaks link if the compiler can't determine the value, but the
> 	linker output is not usually as informative as a compiler error.
> 
> If we use the negative-array-size method *and* the link time trick,
> we get the ability to use BUILD_BUG_ON() under __builtin_constant_p()
> branches, and maximal ability for the compiler to detect errors at
> build time.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks Rusty, this indeed fixes the problem.

Acked-by: Hollis Blanchard <hollisb@us.ibm.com>

-- 
Hollis Blanchard
IBM Linux Technology Center

