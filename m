Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960Ab0AHTdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab0AHTdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 14:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719Ab0AHTdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 14:33:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49618 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab0AHTdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 14:33:15 -0500
Message-ID: <4B4785C3.4030505@zytor.com>
Date: Fri, 08 Jan 2010 11:21:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86: update nr_irqs according cpu num
References: <1262951595-1729-1-git-send-email-yinghai@kernel.org>	<1262951595-1729-5-git-send-email-yinghai@kernel.org> <m1bph4o1il.fsf@fess.ebiederm.org>
In-Reply-To: <m1bph4o1il.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2010 11:11 AM, Eric W. Biederman wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
> 
>> that is max number on run time.
> 
> Ouch!  Unless I misread this code this will leave nr_irqs at
> NR_IRQS_LEGACY. aka 16.
> 
> Let's do something stupid and simple.
> nr_irqs = nr_cpus_ids * 256;  /* Semi-arbitrary number */

This would be 1048576 on the biggest machines we currently support.
Now, the number of IRQ *vectors* is limited to
(224-system vectors)*(cpu count), so one could argue that if there is
anything that is not semi-arbitrary it would be that number, but that
doesn't account for vector sharing.

Do we have any place which requires nr_irqs to be *stable*, or can we
simply treat it as a high water mark for IRQ numbers used?

> Ideally we would set "nr_irqs = 0x7fffffff;" but we have just enough
> places using nr_irqs that I think those loops would get painful if we
> were to do that.

Ideally we should presumably get rid of nr_irqs completely?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

