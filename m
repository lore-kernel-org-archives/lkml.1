Return-Path: <linux-kernel-owner+w=401wt.eu-S932660AbZIDCv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660AbZIDCv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 22:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932566AbZIDCv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 22:51:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:42789 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536AbZIDCvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 22:51:55 -0400
Message-ID: <4AA080A0.7010804@kernel.org>
Date: Fri, 04 Sep 2009 11:51:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, jeremy.fitzhardinge@citrix.com,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86/i386: Make sure stack-protector segment base
 is cache aligned
References: <4AA01893.6000507@goop.org> <tip-1ea0d14e480c245683927eecc03a70faf06e80c8@git.kernel.org> <4AA02687.9080406@zytor.com> <4AA02B02.7080101@goop.org> <4AA031DE.2070109@zytor.com>
In-Reply-To: <4AA031DE.2070109@zytor.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 02:51:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

H. Peter Anvin wrote:
> On 09/03/2009 01:45 PM, Jeremy Fitzhardinge wrote:
>> Two problems:
>>
>>     * gcc generates %gs: references for stack-protector, but we use %fs
>>       for percpu data (because restoring %fs is faster if it's a null
>>       selector; TLS uses %gs).  I guess we could use %fs if
>>       !CONFIG_CC_STACKPROTECTOR, or %gs if we are using it (though that
>>       has some fiddly ramifications for things like ptrace).
> 
> Well, by touching two segments we're getting the worst of both worlds,
> so at least assuming some significant number of real-world deployments
> use CC_STACKPROTECTOR, we really don't want to pessimize that case too much.

Yes, this one definitely seems doable.  BTW, how much performance does
CC_STACKPROTECTOR cost?  That's an ambiguous question but really any
number would help to develop a general sense.  Considering fedora is
doing it by default, I assume it isn't too high?

>>     * The i386 percpu %fs base is offset by -__per_cpu_start from the
>>       percpu variables, so we can directly refer to %fs:per_cpu__foo. 
>>       I'm not sure what it would take to unify i386 to use the same
>>       scheme as x86-64.
> 
> OK, I was under the impression that that had already been done (and no,
> I didn't bother to look at the code.)  I guess I was wrong (and yes,
> this is an absolute precondition.)

I tried this a while ago but hit an obstacle which I don't remember
what exactly was now and decided the conversion wasn't worth the
trouble.  IIRC, it was something substantial.  I'll dig through my
trees.

Thanks.

-- 
tejun
