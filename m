Return-Path: <linux-kernel-owner+w=401wt.eu-S1751598AbYAOLzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbYAOLzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 06:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbYAOLzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 06:55:06 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:18809
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750791AbYAOLzF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 06:55:05 -0500
Message-Id: <478CAD42.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 15 Jan 2008 11:55:30 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [0/31] Great change_page_attr patch series v2
References: <200801141116.534682000@suse.de>
 <478C86E0.76E4.0078.0@novell.com> <200801151106.15452.ak@suse.de>
In-Reply-To: <200801151106.15452.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The one concept that I'm missing (but that I can easily produce a follow-up
>> patch for, as I had this in my c_p_a() changes) is the tracking and adjusting
>> of the reference protection for a large page range that got fully converted
>> to another type (namely relevant for .rodata if it exceeds 2/4 Mb), allowing
>> to use a large page mapping in this case even for non-default mappings.
>
>Ah -- i got rid of that by changing the rodata code to not do this
>except for the debugging case
>
>>>
>CPA: Only unmap kernel init pages in text mapping when CONFIG_DEBUG_RODATA is set
>
>Otherwise the kernel will likely always run with 4K pages instead of 2MB pages,
>which is costly in terms of TLBs.
><<
>
>But you're right that would be an useful feature. But wouldn't it require
>aligning rodata to 2MB in the vmlinux to be really effective? 

Yes, that would be desirable then (and .data should be at a 2/4 Mb
boundary for this, too).

Jan

