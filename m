Return-Path: <linux-kernel-owner+w=401wt.eu-S1762061AbXLQNka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762061AbXLQNka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbXLQNkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:40:22 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:48833
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753468AbXLQNkV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:40:21 -0500
Message-Id: <47668A82.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 17 Dec 2007 13:41:06 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <tglx@linutronix.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       <mingo@redhat.com>, "Andi Kleen" <ak@suse.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix ref-counting bug in change_page_attr()
References: <47610AB5.76E4.0078.0@novell.com>
 <20071217132802.GD1870@elte.hu>
In-Reply-To: <20071217132802.GD1870@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 17.12.07 14:28 >>>
>
>* Jan Beulich <jbeulich@novell.com> wrote:
>
>> When either calling change_page_attr() with the default attributes 
>> pages in the direct mapping have and a page's attributes already were 
>> set to the default or when changing the attributes from one 
>> non-default value to another, the reference counting broke, leading to 
>> either premature restoration of a large page or missing the 
>> opportunity to do so.
>> 
>> At the same time, make __PHYSICAL_MASK_SHIFT on 64-bits the value it 
>> architecturally ought to have.
>
>hm, does this patch fix any real bug seen live? (if yes then do you have 
>links to it, etc?) It would be a v2.6.24 fix in theory but it looks too 
>dangerous for that. So i've queued it up for v2.6.25, for the time 
>being.

I had run into the issue with experimental code of mine quite a while back
(i.e. I don't even recall what exactly I was doing back then). After that I
just continued to keep the fix (which I had submitted before, but which
collided with something in Andi's tree back then iirc).

Jan

