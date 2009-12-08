Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbZLHIXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbZLHIXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 03:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbZLHIXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 03:23:36 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:17982 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbZLHIXg convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;6:2>);
	Tue, 8 Dec 2009 03:23:36 -0500
Message-Id: <4B1E1B1B0200007800024345@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 08 Dec 2009 08:23:39 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <tony.luck@intel.com>, <tj@kernel.org>, <linux-mm@kvack.org>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/vmalloc: don't use vmalloc_end
References: <4B1D3A3302000078000241CD@vpn.id2.novell.com>
 <20091207153552.0fadf335.akpm@linux-foundation.org>
In-Reply-To: <20091207153552.0fadf335.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andrew Morton <akpm@linux-foundation.org> 08.12.09 00:35 >>>
>(cc linux-ia64)
>
>On Mon, 07 Dec 2009 16:24:03 +0000
>"Jan Beulich" <JBeulich@novell.com> wrote:
>
>> At least on ia64 vmalloc_end is a global variable that VMALLOC_END
>> expands to. Hence having a local variable named vmalloc_end and
>> initialized from VMALLOC_END won't work on such platforms. Rename
>> these variables, and for consistency also rename vmalloc_start.
>> 
>
>erk.  So does 2.6.32's vmalloc() actually work correctly on ia64?

According to Tejun the problem is just cosmetic (i.e. causes build
warnings), since the functions affected aren't being used (yet) on
ia64. So feel free to drop the patch again, given that he has a patch
queued to address the issue by renaming the arch variable.

I wonder though why that code is being built on ia64 at all if it's not
being used (i.e. why it doesn't depend on a CONFIG_*, HAVE_*, or
NEED_* manifest constant).

Jan

