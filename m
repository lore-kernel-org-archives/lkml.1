Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbZI3G3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbZI3G3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 02:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZI3G3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 02:29:39 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:50495 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZI3G3i convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;6:2>);
	Wed, 30 Sep 2009 02:29:38 -0400
Message-Id: <4AC316F2020000780001734C@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Sep 2009 07:29:38 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "roel kluin" <roel.kluin@gmail.com>
Cc: <sfr@canb.auug.org.au>, <akpm@linux-foundation.org>,
       <linuxppc-dev@lists.ozlabs.org>, <hollisb@us.ibm.com>,
       <kvm-ppc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-next@vger.kernel.org>
Subject: Re: linux-next: tree build failure
References: <4AC1E15502000078000516B5@vpn.id2.novell.com>
 <25e057c00909290251h55c0dc25o4ab1f2e84c920dca@mail.gmail.com>
In-Reply-To: <25e057c00909290251h55c0dc25o4ab1f2e84c920dca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> roel kluin <roel.kluin@gmail.com> 29.09.09 11:51 >>>
>On Tue, Sep 29, 2009 at 11:28 AM, Jan Beulich <jbeulich@novell.com> wrote:
>>>>> Hollis Blanchard  09/29/09 2:00 AM >>>
>>>First, I think there is a real bug here, and the code should read like
>>>this (to match the comment):
>>>    /* type has to be known at build time for optimization */
>>>-    BUILD_BUG_ON(__builtin_constant_p(type));
>>>+    BUILD_BUG_ON(!__builtin_constant_p(type));
>>>
>>>However, I get the same build error *both* ways, i.e.
>>>__builtin_constant_p(type) evaluates to both 0 and 1? Either that, or
>>>the new BUILD_BUG_ON() macro isn't working...
>>
>> No, at this point of the compilation process it's neither zero nor one,
>> it's simply considered non-constant by the compiler at that stage
>> (this builtin is used for optimization, not during parsing, and the
>> error gets generated when the body of the function gets parsed,
>> not when code gets generated from it).
>>
>> Jan
>
>then maybe
>
>if(__builtin_constant_p(type))
>        BUILD_BUG_ON(1);
>
>would work?

Definitely not - this would result in the compiler *always* generating an
error.

Jan

