Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbZHRPsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbZHRPsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 11:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbZHRPsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 11:48:12 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:46710 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbZHRPsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 11:48:12 -0400
Message-Id: <4A8AE95C020000780001055F@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 18 Aug 2009 16:48:12 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <linux-mm@kvack.org>, "Rusty Russell" <rusty@rustcorp.com.au>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] replace various uses of num_physpages by
	 totalram_pages
References: <4A8AE6280200007800010539@vpn.id2.novell.com>
 <20090818153815.GA11913@elte.hu>
In-Reply-To: <20090818153815.GA11913@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 18.08.09 17:38 >>>
>
>* Jan Beulich <JBeulich@novell.com> wrote:
>
>> Sizing of memory allocations shouldn't depend on the number of 
>> physical pages found in a system, as that generally includes 
>> (perhaps a huge amount of) non-RAM pages. The amount of what 
>> actually is usable as storage should instead be used as a basis 
>> here.
>> 
>> Some of the calculations (i.e. those not intending to use high 
>> memory) should likely even use (totalram_pages - 
>> totalhigh_pages).
>> 
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
>> 
>> ---
>>  arch/x86/kernel/microcode_core.c  |    4 ++--
>
>Acked-by: Ingo Molnar <mingo@elte.hu>
>
>Just curious: how did you find this bug? Did you find this by 
>experiencing problems on a system with a lot of declared non-RAM 
>memory?

Actually, I noticed this on Xen (non-pv-ops) when booting a domain with
a sufficiently large initial balloon. Under that condition, booting would
frequently fail due to various table sizes being calculated way too large.

Jan

