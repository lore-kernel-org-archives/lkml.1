Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbZJZPNC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbZJZPNC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:13:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZJZPNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:13:01 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:52255 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbZJZPNA convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;5:1>);
	Mon, 26 Oct 2009 11:13:00 -0400
Message-Id: <4AE5CA8C020000780001BD09@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 26 Oct 2009 15:13:00 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Yinghai Lu" <yinghai@kernel.org>, <tglx@linutronix.de>,
       "Takashi Iwai" <tiwai@suse.de>, <linux-kernel@vger.kernel.org>,
       <jbarnes@virtuousgeek.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: adjust GFP mask handling for coherent
	 allocations
References: <4AE06644020000780001B4AD@vpn.id2.novell.com>
 <20091023114825.GH5886@elte.hu>
In-Reply-To: <20091023114825.GH5886@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 23.10.09 13:48 >>>
>makes sense (although there were a few odd ends in various ISA sound 
>driver details so this should go on the .33 not .32), but please 
>introduce a cleaner construct, like a new DMA_ISA_BIT_MASK() or so.

Hmm, I could see DMA_ISA_BIT_MASK only replace DMA_BIT_MASK(24)
(but specifically not being conditional upon CONFIG_ISA) without becoming
confusing. Consequently this would eliminate the conditional in the .c
file. And any attempt to eliminate the conditional another way would just
introduce a very similar conditional elsewhere; with this having a single
user (and foreseeably not ever a second one) I would think this would
just make the code less readable.

Or did you have something else in mind that I just don't realize?

Jan

