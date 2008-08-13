Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbYHMSXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbYHMSXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756804AbYHMSXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:23:38 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60253 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbYHMSXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:23:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Huang Ying <ying.huang@intel.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1218618760.24951.137.camel@caritas-dev.intel.com>
	<alpine.LFD.1.10.0808130956360.3462@nehalem.linux-foundation.org>
Date: Wed, 13 Aug 2008 11:12:48 -0700
In-Reply-To: <alpine.LFD.1.10.0808130956360.3462@nehalem.linux-foundation.org>
	(Linus Torvalds's message of "Wed, 13 Aug 2008 09:57:33 -0700 (PDT)")
Message-ID: <m1r68shjhb.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0016]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] kexec jump: fix compiling warning on xchg(&kexec_lock, 0) in kernel_kexec()
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, 13 Aug 2008, Huang Ying wrote:
>>
>> -	xchg(&kexec_lock, 0);
>> +	locked = xchg(&kexec_lock, 0);
>> +	BUG_ON(!locked);
>
> Why do you want to do this at all? 
>
> And why do you implement your locks with xchg() in the first place? That's 
> total and utter crap.
>
> Hint: we have _real_ locking primitives in the kernel.

This part certainly.

The way the code should work, and the way it has in the past is:
image = xchg(&kexec_image, NULL)
if (!image)
   return -EINVAL;

Very simple and very obvious and very easy to get right, and it has
been that way for years.

Eric
