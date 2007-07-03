Return-Path: <linux-kernel-owner+w=401wt.eu-S1759667AbXGCTB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbXGCTB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756789AbXGCTBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:01:52 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:60759 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855AbXGCTBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:01:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=GqoOCxoSX/va0Mi+NDaKDrST0zV0f0xTlpzWLrfGGl7eEAOs4Vs37TXlDG48PNx6tcAd58N4gT2vwz0wwxoyU6X6KXHOBMcu3bSgVLXFXd/+kaHuIUoQwIpYDfwkCeIjdZP8uujVwyFtn6whazMT2uR+m1RGkLzza83Qyw8lc5M=
Message-ID: <3efb10970707031201y7b7eefd3x60136770fcd167fa@mail.gmail.com>
Date: Tue, 3 Jul 2007 21:01:50 +0200
From: "Remy Bohmer" <l.pinguin@gmail.com>
Reply-To: linux@bohmer.net
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Userland PI-futex does not work on ARM (2.6.21.5-rt18)
Cc: andrew@sanpeople.com, "Ingo Molnar" <mingo@elte.hu>,
       "Daniel Walker" <dwalker@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

I am using the 2.6.21.5-rt18 kernel on the ARM core Atmel at91rm9200
together with a Glibc 2.5+GCC4.2.0 toolchain, and I found out that the
userland PI futexes (configured with PTHREAD_PRIO_INHERIT) do not
work.

What happens is:
* Thread A claims the mutex, and gets the lock.
* Thread B claims the mutex, and *also* gets the lock. (this is
obviously already wrong)
* Thread A wants to release the mutex and that fails because it does
not own it...

It looks like mutexes configured *without* PTHREAD_PRIO_INHERIT seem
to work fine, but have not tested that thouroughly.

Is this problem already known, or am I the first person running into it?


Kind Regards,

Remy Böhmer
