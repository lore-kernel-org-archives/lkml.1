Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbYAZGIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbYAZGIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 01:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbYAZGII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 01:08:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47051 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbYAZGIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 01:08:07 -0500
Message-ID: <479ACD43.6060003@zytor.com>
Date: Fri, 25 Jan 2008 22:03:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Keir Fraser <Keir.Fraser@cl.cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, William Irwin <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 11 of 11] x86: defer cr3 reload when doing pud_clear()
References: <C3C0235A.12D8E%Keir.Fraser@cl.cam.ac.uk> <479A7463.7070801@goop.org> <20080126001128.GB24559@elte.hu> <200801260657.04398.ak@suse.de>
In-Reply-To: <200801260657.04398.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
>> so INVLPG makes sense for pagetable fault realated single-address 
>> flushes, but they rarely make sense for range flushes. (and that's how 
>> Linux uses it)
> 
> I think it would be an interesting experiment to switch flush_tlb_range()
> over to INVLPG if the length is below some threshold and see if there 
> are visible effects in macro benchmarks. The main problem
> would be to determine the right threshold -- would likely be CPU dependent.
> 

It would be an interesting experiment.  Odds are pretty good that the 
cutover is roughly linear in the TLB size.

	-hpa
