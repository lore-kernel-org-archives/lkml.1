Return-Path: <linux-kernel-owner+w=401wt.eu-S1762742AbYD3OwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762742AbYD3OwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 10:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759020AbYD3OwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 10:52:07 -0400
Received: from gw.goop.org ([64.81.55.164]:43832 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758743AbYD3OwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 10:52:05 -0400
Message-ID: <48188786.7020609@goop.org>
Date: Wed, 30 Apr 2008 07:51:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 2/10] x86: convert to generic helpers for IPI function
 calls
References: <1209453990-7735-1-git-send-email-jens.axboe@oracle.com> <1209453990-7735-3-git-send-email-jens.axboe@oracle.com> <481786A5.7010604@goop.org> <20080430113542.GZ12774@kernel.dk> <20080430122001.GS11126@linux.vnet.ibm.com> <20080430123136.GB12774@kernel.dk>
In-Reply-To: <20080430123136.GB12774@kernel.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Xen could just stuff that bit into its arch_send_call_function_ipi(),
> something like the below should be fine. My question to Jeremy was more
> of the order of whether it should be kept or not, I guess it's safer to
> just keep it and retain the existing behaviour (and let Jeremy/others
> evaluate it at will later on). Note that I got rid of the yield bool and
> break when we called the hypervisor.
>   

Yes, it's a nice cleanup.

> Jeremy, shall I add this?
>   

Hold off for now.  Given that its effects are unmeasured, I'm not even 
sure its the right thing to do.  For example, it will yield if you're 
sending an IPI to a vcpu which wants to run but can't, but does nothing 
for an idle vcpu.  And always yielding may be a performance problem if 
the IPI doesn't involve any cpu contention.

It's easy to add back if it turns out to be useful.

    J
