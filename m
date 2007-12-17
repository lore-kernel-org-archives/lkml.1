Return-Path: <linux-kernel-owner+w=401wt.eu-S1761265AbXLQNg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761265AbXLQNg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbXLQNgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:36:50 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:48673
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480AbXLQNgu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:36:50 -0500
Message-Id: <476689AF.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 17 Dec 2007 13:37:35 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <tglx@linutronix.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       <mingo@redhat.com>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: make pda's cpunumber and nodenumber
	unsigned
References: <47610530.76E4.0078.0@novell.com>
 <20071217132619.GB1870@elte.hu>
In-Reply-To: <20071217132619.GB1870@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 17.12.07 14:26 >>>
>
>* Jan Beulich <jbeulich@novell.com> wrote:
>
>> This generally allows better code to be generated, since the zero- 
>> extension during 32-bit operations comes for free (needed when the 
>> result is used as array index or similar), whereas sign extension must 
>> be done explicitly and frequently requires a one byte larger 
>> instruction due to the necessary rex64 prefix.
>
>good catch! Applied your patch to x86.git - queued it up for v2.6.25. I 
>bet there are tons of other instances where we use signed instead of 
>unsigned and get worse code generation.

Yes, definitely. This patch was kind of a testing one whether this is a
welcome change. As it appears to be, I'll probably produce more as I
run into respective cases.

Jan

