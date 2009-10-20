Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbZJTB3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbZJTB3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 21:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbZJTB3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 21:29:53 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59693 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756276AbZJTB3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 21:29:52 -0400
Subject: Re: linux-next: tree build failure
From: Hollis Blanchard <hollisb@us.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jan Beulich <JBeulich@novell.com>, sfr@canb.auug.org.au,
       akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
       kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
In-Reply-To: <200910201142.34006.rusty@rustcorp.com.au>
References: <4AC1E15502000078000516B5@vpn.id2.novell.com>
	 <4AD6EB17020000780001A050@vpn.id2.novell.com>
	 <1255976369.13995.98.camel@slab.beaverton.ibm.com>
	 <200910201142.34006.rusty@rustcorp.com.au>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Mon, 19 Oct 2009 18:29:53 -0700
Message-Id: <1256002193.6546.2.camel@slab>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-20 at 11:42 +1030, Rusty Russell wrote:
> On Tue, 20 Oct 2009 04:49:29 am Hollis Blanchard wrote:
> > On Thu, 2009-10-15 at 08:27 +0100, Jan Beulich wrote:
> > > My perspective is that it just uncovered already existing brokenness.
> > 
> > Sorry, I thought it was clear, but to be more explicit: I propose the
> > following patch, which replaces the current BUILD_BUG_ON implementation
> > with Rusty's version.
> 
> OK, I switched my brain back on.  Yeah, I agree: we may still want
> BUILD_OR_RUNTIME_BUG_ON one day, but I like this.
> 
> It's just missing the giant comment that it needs :)
> 
> /**
>  * BUILD_BUG_ON - break compile if a condition is true.
>  * @cond: the condition which the compiler should know is false.
>  *
>  * If you have some code which relies on certain constants being equal, or
>  * other compile-time-evaluated condition, you should use BUILD_BUG_ON to
>  * detect if someone changes it.
>  *
>  * The implementation uses gcc's reluctance to create a negative array, but
>  * gcc (as of 4.4) only emits that error for obvious cases (eg. not arguments
>  * to inline functions).  So as a fallback we use the optimizer; if it can't
>  * prove the condition is false, it will cause a link error on the undefined
>  * "__build_bug_on_failed".  This error is less neat, and can be harder to
>  * track down.
>  */

Do you want to put together a signed-off patch Rusty? It's your code, so
I don't feel comfortable doing that.

Once we have that, can we remove the mysterious MAYBE_BUILD_BUG_ON
statements introduced in previous patches? (Does it BUG or doesn't it??)

-- 
Hollis Blanchard
IBM Linux Technology Center

