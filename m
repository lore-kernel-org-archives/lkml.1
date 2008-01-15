Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbYAOIkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbYAOIkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 03:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751084AbYAOIkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 03:40:10 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:8007
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbYAOIkI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 03:40:08 -0500
Message-Id: <478C7F8B.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 15 Jan 2008 08:40:27 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <ak@suse.de>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [12/31] CPA: CLFLUSH support in change_page_attr()
References: <200801141116.534682000@suse.de>
 <20080114221644.816F314F83@wotan.suse.de>
In-Reply-To: <20080114221644.816F314F83@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-	/* clflush is still broken. Disable for now. */
>-	if (1 || !cpu_has_clflush)
>+	if (a->full_flush)
> 		asm volatile("wbinvd" ::: "memory");
>-	else list_for_each_entry(pg, l, lru) {
>-		void *adr = page_address(pg);
>-		clflush_cache_range(adr, PAGE_SIZE);
>+	list_for_each_entry(f, &a->l, l) {
>+		if (!a->full_flush)

This if() looks redundant (could also be avoided in the 32-bit variant, but
isn't redundant there at present). Also, is there no
wbinvd() on 64bit?

Jan

