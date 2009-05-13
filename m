Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbZEMMvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbZEMMvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 08:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbZEMMvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 08:51:22 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:47659 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbZEMMvW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 08:51:22 -0400
Message-Id: <4A0ADE6A0200007800000BA7@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 13 May 2009 13:51:22 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Tejun Heo" <TeHeo@novell.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: remap allocator for per-CPU memory
References: <4A09B23B02000078000007F1@vpn.id2.novell.com>
 <4A09991E.9010903@kernel.org> <4A0A9C70.6090803@novell.com>
 <87vdo5l0u6.fsf@basil.nowhere.org> <4A0AAB6B.3090903@novell.com>
 <4A0AAF10.3030709@novell.com>
In-Reply-To: <4A0AAF10.3030709@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Tejun Heo <teheo@novell.com> 13.05.09 13:29 >>>
>Tejun Heo wrote:
>> Andi Kleen wrote:
>>> Tejun Heo <teheo@novell.com> writes:
>>>> Okay, just glanced over the pageattr code.  I don't think we need any
>>>> special provisions for this as long as the TLB is fine with having
>>>> overlapping PMD and PTE mappings with different attributes (please
>>>> note that these two mappings aren't occupying the same linear
>>>> addresses - they're aliases).  This is allowed, right?
>>> Nope.
>> 
>> Yeah, I'm going through the manual now and can't find anything which
>> allows such behavior.  I haven't been able to find anything which
>>> describes what happens between large page and 4k page aliases.
>> Aieee...  I'll dig through the manual a bit more and see whether this
>> can be worked around somehow.  :-(
>
>Looks like we're screwed.
>
>I couldn't find anything explicitly prohibiting PMD/PTE aliases w/
>different attributes although there are plenty of warnings and don'ts
>against giving different attributes to the same linear addresses.  At
>any rate, it definitely looks way too dangerous to depend on.
>
>And, set_memory_*() is basically allowed on any memory allocated via
>get_free_page(), so... we're between rock and hard place.  Looks like
>remapping partially using large pages is no go.
>
>Any ideas?

I think the only two alternatives are

(a) don't use large pages in the first place here, or

(b) teach the pageattr code to handle the per-CPU virtual area similarly to
the kernel space for x86-64 (though it's going to be a little more complicated
since there's no pre-determined relation between the virtual and physical
addresses - the necessary lookup might become expensive on systems with
very many [possible] CPUs).

Jan

