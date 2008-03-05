Return-Path: <linux-kernel-owner+w=401wt.eu-S1762892AbYCEGsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892AbYCEGsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 01:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758125AbYCEGs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 01:48:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35064 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756088AbYCEGs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 01:48:26 -0500
Date: Wed, 5 Mar 2008 07:48:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: preempt bug in set_pmd_pfn?
Message-ID: <20080305064814.GB28398@elte.hu>
References: <47CDBB87.8090906@goop.org> <20080304212821.GB8944@elte.hu> <47CDBEDC.1050302@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CDBEDC.1050302@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>
>>   
>>> I think set_pmd_pfn, which is only called by __set_fixmap, might have a 
>>> preempt bug in it.
>>>     
>>
>> yes, and we had similar preemption bugs in the past. I guess most places 
>> are either infrequent or have some natural atomicity anyway. Wanna send a 
>> patch?
>
> Sure.  Should it just disable preemption, or take a lock?  It calls 
> set_pte_at without holding any pte locks; that seems to be relatively 
> common.  Is it OK when you're operating on init_mm?

no, it's not OK to modify the kernel pagetable without locking - taking 
the pgd_lock should do the trick. Could you send the stacktrace that 
shows the place that is preemptible?

	Ingo
