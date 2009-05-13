Return-Path: <linux-kernel-owner+w=401wt.eu-S1760356AbZEMNoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760356AbZEMNoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbZEMNoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:44:10 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:50596 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZEMNoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:44:09 -0400
Message-Id: <4A0AEAC80200007800000BC3@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 13 May 2009 14:44:08 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Tejun Heo" <TeHeo@novell.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: remap allocator for per-CPU memory
References: <4A09B23B02000078000007F1@vpn.id2.novell.com>
 <4A09991E.9010903@kernel.org> <4A0A9C70.6090803@novell.com>
 <87vdo5l0u6.fsf@basil.nowhere.org> <4A0AAB6B.3090903@novell.com>
 <4A0AAF10.3030709@novell.com> <4A0ADE6A0200007800000BA7@novell.com>
 <4A0ACB29.5030009@novell.com>
In-Reply-To: <4A0ACB29.5030009@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Tejun Heo <teheo@novell.com> 13.05.09 15:29 >>>
>> (b) teach the pageattr code to handle the per-CPU virtual area similarly to
>> the kernel space for x86-64 (though it's going to be a little more complicated
>> since there's no pre-determined relation between the virtual and physical
>> addresses - the necessary lookup might become expensive on systems with
>> very many [possible] CPUs).
>
>Can you elaborate this a bit?  Let's sya there's quick way to match
>whether the page is part of the remapped large page, what can pageattr
>do differently then?  Applying the same attribute to both mappings?
>Failing or filtering set_memory_*()?

It would have to split the page. Perhaps there wouldn't be a need to apply the
new attribute to the page(s) that is(are) in the process of getting its(their)
attribute(s) changed; instead, just don't re-establish a 4k mapping for those
pages that aren't part of the per-CPU space.

And of course, the request should fail when it targets one of the pages that
are actually part of the per-CPU space -- but would be a BUG() anyway.

Jan

