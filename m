Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbYFIPyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbYFIPyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYFIPx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:53:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbYFIPx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:53:58 -0400
Message-ID: <484D5119.5020206@redhat.com>
Date: Mon, 09 Jun 2008 12:49:45 -0300
From: Glauber Costa <gcosta@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, hugh@veritas.com
Subject: Re: [PATCH 03/15] x86: remove early_gdt_descr reference
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>	 <1213021018-14159-2-git-send-email-gcosta@redhat.com>	 <1213021018-14159-3-git-send-email-gcosta@redhat.com>	 <1213021018-14159-4-git-send-email-gcosta@redhat.com> <1213024983.3508.28.camel@localhost.localdomain>
In-Reply-To: <1213024983.3508.28.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Mon, 2008-06-09 at 11:16 -0300, Glauber Costa wrote:
>> since we use switch_to_new_gdt, there is no point
>> in assigning early_gdt_descr except for the first
>> assignment, which is done manually.
> 
> What makes you think you can do this?  If you don't update the early
> boot gdt, they all end up using the Boot CPU one.  The problem with this
> is that there's a time from start_secondary to switch_to_new_gdt where
> the per cpu selector (%fs) and the pda selector (%gs) are those of the
> boot CPU.   The former isn't a problem but the CPU number is in the
> latter, and it's used in that path before we get to the initialisation.

You are right, I missed it.

However, it only seem to be used in cpu_init, and very early. Sure there 
are some users _before_ we load the new gdt, but nothing prevents them 
to be moved after it. (Of course, this patch is wrong anyway).

And if we do that, we can even take the %fs loading out of head_32.S
Of course, it's only valid if those are indeed the only early users of it.

Is there any other use I'm missing?

