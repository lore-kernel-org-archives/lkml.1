Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbZJNINW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbZJNINW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 04:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757660AbZJNINV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 04:13:21 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:32929 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033AbZJNINU convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;10:1>);
	Wed, 14 Oct 2009 04:13:20 -0400
Message-Id: <4AD5A4540200007800019CE9@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 14 Oct 2009 09:13:40 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Thomas Schlichter" <thomas.schlichter@web.de>
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "Robert Hancock" <hancockrwd@gmail.com>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Tejun Heo" <tj@kernel.org>, <x86@kernel.org>,
       "Yinghai Lu" <yinghai@kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       <dri-devel@lists.sourceforge.net>, "Ingo Molnar" <mingo@redhat.com>,
       <linux-kernel@vger.kernel.org>, <jbarnes@virtuousgeek.org>,
       "Thomas Hellstrom" <thellstrom@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
	 available
References: <4AD449A702000078000197EE@vpn.id2.novell.com>
 <200910132329.05152.thomas.schlichter@web.de>
In-Reply-To: <200910132329.05152.thomas.schlichter@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Thomas Schlichter <thomas.schlichter@web.de> 13.10.09 23:29 >>>
>Jan Beulich wrote:
>> >>> Thomas Schlichter <thomas.schlichter@web.de> 12.10.09 20:32 >>>
>> >+	if (!pat_enabled) {
>> >+		void __iomem *ret = ioremap_nocache(phys_addr, size);
>> >+		if (ret)
>> >+			mtrr_add(phys_addr, size, MTRR_TYPE_WRCOMB, false);
>> 
>> This won't work if phys_addr or size aren't page aligned, or if size isn't
>> a power of two.
>
>No, at least the comments in mtrr_add and mtrr_check state that it is just 
>required that phys_addr and size are multiple of PAGE_SIZE. And I'm not sure 
>if it is always safe to round these up/down to the next PAGE boundary. If it 
>is not, maybe it is better to fail...

That function isn't the limiting factor, generic_validate_add_page() is
what you need to look at (plus the spec on how the MTRR ranges are
calculated by the CPU from the base/mask register pairs).

Jan

