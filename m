Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbXEQTmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbXEQTmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 15:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757456AbXEQTmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 15:42:14 -0400
Received: from h155.mvista.com ([63.81.120.155]:25494 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756941AbXEQTmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 15:42:13 -0400
Message-ID: <464CB071.5050504@ru.mvista.com>
Date: Thu, 17 May 2007 23:43:45 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
References: <200705172142.26739.sshtylyov@ru.mvista.com> <f9afbdb49bc1f935153305315770bccd@kernel.crashing.org>
In-Reply-To: <f9afbdb49bc1f935153305315770bccd@kernel.crashing.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool wrote:
>> +     * We must write a positive value to the decrementer to clear
>> +     * the interrupt on the IBM 970 CPU series.  In periodic mode,
>> +     * this happens when the decrementer gets reloaded later, but
>> +     * in one-shot mode, we have to do it here since an event handler
>> +     * may skip loading the new value...

> Nothing special about 970 here -- on *every* PowerPC,
> a decrementer exception exists as long as the high
> bit of the decrementer equals 1.  BookE is different
> of course.  Some other CPUs might deviate from the
> architecture as well.

    Quoting "PowerPC Operating Environment Architecture":

The Decrementer counts down. On POWER4, a Decrementer exception occurs when 
DEC0 changes from 0 to 1. On POWER4+, operation is as follows.

The exception effects of the Decrementer are said to be consistent with the 
contents of the Decrementer if one of the following statements is true.

* DEC0=0 and a Decrementer exception does not exist.

* DEC0=1 and a Decrementer exception exists.

If DEC0=0, a context synchronizing instruction or event ensures that the 
exception effects of the Decrementer are consistent with the contents of the 
Decrementer. Otherwise, when the contents of DEC0 change, the exception 
effects of the Decrementer become consistent with the new contents of the 
Decrementer reasonably soon after the change.

> Segher

WBR, Sergei
