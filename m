Return-Path: <linux-kernel-owner+w=401wt.eu-S1756314AbZICVQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbZICVQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 17:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbZICVQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 17:16:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58734 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210AbZICVQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 17:16:35 -0400
Message-ID: <4AA031DE.2070109@zytor.com>
Date: Thu, 03 Sep 2009 14:15:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org,
       jeremy.fitzhardinge@citrix.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Subject: Re: [tip:x86/asm] x86/i386: Make sure stack-protector segment base
 is cache aligned
References: <4AA01893.6000507@goop.org> <tip-1ea0d14e480c245683927eecc03a70faf06e80c8@git.kernel.org> <4AA02687.9080406@zytor.com> <4AA02B02.7080101@goop.org>
In-Reply-To: <4AA02B02.7080101@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2009 01:45 PM, Jeremy Fitzhardinge wrote:
> 
> Two problems:
> 
>     * gcc generates %gs: references for stack-protector, but we use %fs
>       for percpu data (because restoring %fs is faster if it's a null
>       selector; TLS uses %gs).  I guess we could use %fs if
>       !CONFIG_CC_STACKPROTECTOR, or %gs if we are using it (though that
>       has some fiddly ramifications for things like ptrace).

Well, by touching two segments we're getting the worst of both worlds,
so at least assuming some significant number of real-world deployments
use CC_STACKPROTECTOR, we really don't want to pessimize that case too much.

>     * The i386 percpu %fs base is offset by -__per_cpu_start from the
>       percpu variables, so we can directly refer to %fs:per_cpu__foo. 
>       I'm not sure what it would take to unify i386 to use the same
>       scheme as x86-64.

OK, I was under the impression that that had already been done (and no,
I didn't bother to look at the code.)  I guess I was wrong (and yes,
this is an absolute precondition.)

> Neither looks insoluble.

Agreed.  Looks like something that can and probably should be done but
is a bit further out.

	-hpa
