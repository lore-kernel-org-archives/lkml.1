Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbZEML3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbZEML3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 07:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759121AbZEML32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 07:29:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:38453 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759059AbZEML31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 07:29:27 -0400
Message-ID: <4A0AAF10.3030709@novell.com>
Date: Wed, 13 May 2009 20:29:20 +0900
From: Tejun Heo <teheo@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: remap allocator for per-CPU memory
References: <4A09B23B02000078000007F1@vpn.id2.novell.com>	<4A09991E.9010903@kernel.org> <4A0A9C70.6090803@novell.com> <87vdo5l0u6.fsf@basil.nowhere.org> <4A0AAB6B.3090903@novell.com>
In-Reply-To: <4A0AAB6B.3090903@novell.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Andi Kleen wrote:
>> Tejun Heo <teheo@novell.com> writes:
>>> Okay, just glanced over the pageattr code.  I don't think we need any
>>> special provisions for this as long as the TLB is fine with having
>>> overlapping PMD and PTE mappings with different attributes (please
>>> note that these two mappings aren't occupying the same linear
>>> addresses - they're aliases).  This is allowed, right?
>> Nope.
> 
> Yeah, I'm going through the manual now and can't find anything which
> allows such behavior.  I haven't been able to find anything which
> describes what happens between large page and 4k page aliases.
> Aieee...  I'll dig through the manual a bit more and see whether this
> can be worked around somehow.  :-(

Looks like we're screwed.

I couldn't find anything explicitly prohibiting PMD/PTE aliases w/
different attributes although there are plenty of warnings and don'ts
against giving different attributes to the same linear addresses.  At
any rate, it definitely looks way too dangerous to depend on.

And, set_memory_*() is basically allowed on any memory allocated via
get_free_page(), so... we're between rock and hard place.  Looks like
remapping partially using large pages is no go.

Any ideas?

Thanks.

-- 
tejun
