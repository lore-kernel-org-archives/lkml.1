Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbZEMNwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbZEMNwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZEMNwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:52:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40277 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbZEMNwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:52:11 -0400
Message-ID: <4A0AD0D3.6030802@novell.com>
Date: Wed, 13 May 2009 22:53:23 +0900
From: Tejun Heo <teheo@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: remap allocator for per-CPU memory
References: <4A09B23B02000078000007F1@vpn.id2.novell.com> <4A09991E.9010903@kernel.org> <4A0A9C70.6090803@novell.com> <87vdo5l0u6.fsf@basil.nowhere.org> <4A0AAB6B.3090903@novell.com> <4A0AAF10.3030709@novell.com> <4A0ADE6A0200007800000BA7@novell.com> <4A0ACB29.5030009@novell.com> <4A0AEAC80200007800000BC3@vpn.id2.novell.com>
In-Reply-To: <4A0AEAC80200007800000BC3@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.

Jan Beulich wrote:
>>>> Tejun Heo <teheo@novell.com> 13.05.09 15:29 >>>
>>> (b) teach the pageattr code to handle the per-CPU virtual area similarly to
>>> the kernel space for x86-64 (though it's going to be a little more complicated
>>> since there's no pre-determined relation between the virtual and physical
>>> addresses - the necessary lookup might become expensive on systems with
>>> very many [possible] CPUs).
>> Can you elaborate this a bit?  Let's sya there's quick way to match
>> whether the page is part of the remapped large page, what can pageattr
>> do differently then?  Applying the same attribute to both mappings?
>> Failing or filtering set_memory_*()?
> 
> It would have to split the page. Perhaps there wouldn't be a need to
> apply the new attribute to the page(s) that is(are) in the process
> of getting its(their) attribute(s) changed; instead, just don't
> re-establish a 4k mapping for those pages that aren't part of the
> per-CPU space.

Ah... right.  Splitting the remapped area should do the trick, so now
the question is whether it would worth all the trouble or should we
just forget about remapping and use 4k on NUMA machines.  I don't have
much clue here.  Andi seems to think there's no reason to bother with
PMD mappings.  Ingo, what do you think?

Thanks.

-- 
tejun
