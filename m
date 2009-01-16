Return-Path: <linux-kernel-owner+w=401wt.eu-S936878AbZAPSom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936878AbZAPSom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 13:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762484AbZAPSob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 13:44:31 -0500
Received: from h155.mvista.com ([63.81.120.155]:54109 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757673AbZAPSob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 13:44:31 -0500
Message-ID: <4970D5B0.5010209@ru.mvista.com>
Date: Fri, 16 Jan 2009 21:45:04 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
References: <20090116152721.GA6994@havoc.gtf.org> <20090116093101.6d77b69b.akpm@linux-foundation.org>
In-Reply-To: <20090116093101.6d77b69b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andrew Morton wrote:

>>+static unsigned int ns_to_tim_reg(unsigned int tim_mult, unsigned int nsecs)
>>+{
>>+	unsigned int val;
>>+
>>+	/*
>>+	 * Compute # of eclock periods to get desired duration in
>>+	 * nanoseconds.
>>+	 */
>>+	val = DIV_ROUND_UP(nsecs * (octeon_get_clock_rate() / 1000000),
>>+			  1000 * tim_mult);
>>+
>>+	return val;
>>+}

> There's great potential for overflows here, but I couldn't be bothered
> picking through it.  Are we sure that it's watertight?

> There's a 64-bit divide in there.  Will it link on 32-bit platforms?

> Or is this all 64-bit-only code?

> wtf is an octeon anyway?  (greps).  Some MIPS thing.  I guess it's
> 64-bit-only.

    Yes, it's multicore MIPS64. AFAIK, it should be able to run 32-bit kernel 
(don't think that it's really worth it).

WBR, Sergei
