Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123Ab0AHVYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab0AHVYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 16:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949Ab0AHVYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 16:24:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44930 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab0AHVY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 16:24:29 -0500
Message-ID: <4B47A085.1010703@zytor.com>
Date: Fri, 08 Jan 2010 13:15:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86: update nr_irqs according cpu num
References: <1262951595-1729-1-git-send-email-yinghai@kernel.org>	<1262951595-1729-5-git-send-email-yinghai@kernel.org>	<m1bph4o1il.fsf@fess.ebiederm.org> <4B4785C3.4030505@zytor.com> <m1my0oici4.fsf@fess.ebiederm.org>
In-Reply-To: <m1my0oici4.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2010 12:10 PM, Eric W. Biederman wrote:
> 
> I don't know if we ever actually perform vector sharing.  The only case
> I recall where the code could share vectors is if the firmware tables
> told us to irq sources were the same interrupt.  I don't think that
> happens.  We do have the remains of support for vector sharing
> in the code but I don't think it is utilized.  MSI interrupts certainly
> can not share vectors.
> 

We probably will need to support that at some point, though, simply
because it's not all that hard to construct a system in which there are
more MSI-X interrupts than there are possible vectors in the system.

Until then we can do 224 * nr_cpus_ids, but it's still not the right thing.

> Yes.  It was enough of a pain the first pass at it that we wound
> up with nr_irqs, a value that can vary at boot time.
> 
> Once YH's radix tree changes get it in.  A war on NR_IRQS and nr_irqs
> seems appropriate.

Agreed.

	-hpa

