Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbZJaAbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbZJaAbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 20:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757541AbZJaAbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 20:31:21 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36259 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538AbZJaAbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 20:31:20 -0400
Message-ID: <4AEB8554.3050109@us.ibm.com>
Date: Fri, 30 Oct 2009 17:31:16 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Arnd Bergmann <arnd@arndb.de>, "lkml, " <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       "Stultz, John" <johnstul@us.ibm.com>
Subject: Re: [PATCH] RFC: futex: make futex_lock_pi interruptible
References: <4AE63E3D.8030903@us.ibm.com> <4AE63FA3.8040208@us.ibm.com> <200910290939.32485.arnd@arndb.de> <4AEA3F15.2070900@us.ibm.com> <4AEA4547.30102@us.ibm.com> <4AEB2885.5040406@nortel.com>
In-Reply-To: <4AEB2885.5040406@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> On 10/29/2009 07:45 PM, Darren Hart wrote:
> 
>> This appears to work fine. Can anyone think of a reason why this is an unsafe
>> thing to do? I'll have to create a much more elaborate test case and review
>> the glibc code of course to make sure the glibc mutex state isn't compromised.
> 
> Setting aside the specific code details, I would suggest that you not
> review the glibc code but rather review the glibc documentation and the
> susv3/posix specifications.  That way, if it behaves according to the
> spec but breaks glibc you can push for a patch to glibc.
> 
> If it happens to work with current glibc but is not standards-compliant,
> then it could break in the future.

Unfortunately, pthread_mutex_lock() by spec shall not return -EINTR nor 
is it a valid pthread_cancelation point. We can do the latter with a 
non-posix extension in glibc. In order to provide an 
interruptible/cancelable mutex, we would also be non-posix - at least, 
if we provided a mechanism directly within glibc.

If folks think this signal based approach is the why to go, then you are 
correct, we just need to make sure that the spec allows us to use 
set/longjmp in this context.



-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
