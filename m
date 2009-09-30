Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbZI3GfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbZI3GfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 02:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbZI3GfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 02:35:17 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:50975 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbZI3GfQ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;5:2>);
	Wed, 30 Sep 2009 02:35:16 -0400
Message-Id: <4AC318450200007800017355@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Sep 2009 07:35:17 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Hollis Blanchard" <hollisb@us.ibm.com>
Cc: <sfr@canb.auug.org.au>, <akpm@linux-foundation.org>,
       <linuxppc-dev@lists.ozlabs.org>, <kvm-ppc@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>
Subject: Re: linux-next: tree build failure
References: <4AC1E15502000078000516B5@vpn.id2.novell.com>
 <1254267572.15622.1621.camel@slab.beaverton.ibm.com>
In-Reply-To: <1254267572.15622.1621.camel@slab.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Hollis Blanchard <hollisb@us.ibm.com> 30.09.09 01:39 >>>
>On Tue, 2009-09-29 at 10:28 +0100, Jan Beulich wrote:
>> >>> Hollis Blanchard  09/29/09 2:00 AM >>>
>> >First, I think there is a real bug here, and the code should read like
>> >this (to match the comment):
>> >    /* type has to be known at build time for optimization */
>> >-    BUILD_BUG_ON(__builtin_constant_p(type));
>> >+    BUILD_BUG_ON(!__builtin_constant_p(type));
>> >
>> >However, I get the same build error *both* ways, i.e.
>> >__builtin_constant_p(type) evaluates to both 0 and 1? Either that, or
>> >the new BUILD_BUG_ON() macro isn't working...
>> 
>> No, at this point of the compilation process it's neither zero nor one,
>> it's simply considered non-constant by the compiler at that stage
>> (this builtin is used for optimization, not during parsing, and the
>> error gets generated when the body of the function gets parsed,
>> not when code gets generated from it).
>
>I think I see what you're saying. Do you have a fix to suggest?

The one Rusty suggested the other day may help here. I don't like it
as a drop-in replacement for BUILD_BUG_ON() though (due to it
deferring the error generated to the linking stage), I'd rather view
this as an improvement to MAYBE_BUILD_BUG_ON() (which should
then be used here).

Jan

