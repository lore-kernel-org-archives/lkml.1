Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbZAFWh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbZAFWh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755584AbZAFWXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:23:25 -0500
Received: from fe01x03-cgp.akado.ru ([77.232.31.164]:59003 "EHLO akado.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756146AbZAFWXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:23:22 -0500
Date: Wed, 7 Jan 2009 01:23:19 +0300 (MSK)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@linmac.oyster.ru
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: Lock-up on PPC64
In-Reply-To: <1231276643.14860.30.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0901070105510.4695@linmac.oyster.ru>
References: <Pine.LNX.4.64.0812212058550.2164@linmac.oyster.ru>
 <20081222233223.GA6688@joi> <877i5rh9rm.fsf@linmac.oyster.ru>
 <20081223234513.GA8730@deepthought> <871vvy77v4.fsf@linmac.oyster.ru>
 <1230165163.7292.32.camel@pasglop> <Pine.LNX.4.64.0812280335070.2526@linmac.oyster.ru>
 <1231158516.8367.3.camel@localhost> <Pine.LNX.4.64.0901051928200.2208@linmac.oyster.ru>
 <1231243373.14860.24.camel@pasglop> <Pine.LNX.4.64.0901062032550.2972@linmac.oyster.ru>
 <1231276643.14860.30.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009, Benjamin Herrenschmidt wrote:

>
>> As you wish :) I've written some ad-hoc stuff in the failing path which
>> manually triggers sysrq and then sends the klogctl output via network
>> and here it is:
>
> Allright, something's unclear to me. What do you mean by the system goes
> down then ? The kernel appears to be working at least to a certain
> extent if you manage to trigger a sysrq from userspace... And from what
> I see, it looks that all processes are somewhere in schedule.
>
> So what is precisely your symptom here ?

Okay full setup is like this:

1. Default ydl kernel (2.6.23) (i.e. without XER.SO patch)

2. Mono with mono_handle_native_sigsegv augmented with code
    that write(2)s a byte to an file which corresponds to a FIFO

3. Small application that is blocking on the read side of the FIFO and
    upon receiving anything, write(2)s "t\nd\n" to /proc/sysrq-trigger,
    then grabs the printk buffer via klogctl and send(2)s it.

Given all that, I have two connections to PS3 - one is running the
dlog (application described in item 3), and the other is used to run
Mono with arguments that lead to the lock up.

After Mono is invoked one can see that mono_handle_native_sigsegv is
executed (few debugging write(2)s) and also that local copy of nc,
which dlog connects to, has received printk buffer, PS3 meanwhile
locks up.

Hope it's clearer now, if not, please, do ask.

-- 
mailto:av1474@comtv.ru
