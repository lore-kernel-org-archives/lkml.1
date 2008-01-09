Return-Path: <linux-kernel-owner+w=401wt.eu-S1758447AbYAIBMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbYAIBMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbYAIBMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:12:35 -0500
Received: from mail.suse.de ([195.135.220.2]:40427 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752236AbYAIBMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:12:35 -0500
Date: Wed, 9 Jan 2008 02:12:33 +0100
From: Andi Kleen <ak@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
Message-ID: <20080109011233.GD25945@bingen.suse.de>
References: <20080108232803.GA19906@elte.hu> <20080108234449.GA24274@elte.hu> <20080109000146.GA29095@elte.hu> <47841194.2010208@goop.org> <20080109002014.GB31289@elte.hu> <20080109002803.GA3732@elte.hu> <20080109003034.GA4658@elte.hu> <47841B09.3020507@goop.org> <20080109005914.GA24228@elte.hu> <47841E3C.9020106@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47841E3C.9020106@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 05:07:08PM -0800, Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
>> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>
>>   
>>> In other words, prot and ref_prot can never be equal, so this path is 
>>> always taken, and the other branch which tests pte_huge() is never run.
>>>
>>> Andi?  Jan?  Is this code just buggy, or is there something else going on 
>>> here?
>>>     
>>
>> this code is plain buggy but fixing it triggered driver bugs in the past 
>> so we've been procrastinating it forever ...
>>   
>
> What kind of driver bugs?  Do drivers manage to get into the other branch 

That was just the return value issue that caused drivers to fail through
ioremap() iirc. It would error out for unmapped holes and then fail
ioremap I don't think it's related.


> of the if()?  If not, can't we just remove it and avoid this present 
> problem?

That would just hide your problem.

-Andi
