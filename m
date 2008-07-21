Return-Path: <linux-kernel-owner+w=401wt.eu-S1756408AbYGUILh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbYGUILh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 04:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbYGUILW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 04:11:22 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:19072 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbYGUILU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 04:11:20 -0400
Message-Id: <488460E0.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Mon, 21 Jul 2008 09:11:44 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <andi@firstfloor.org>, "Takashi Iwai" <tiwai@suse.de>
Cc: <robert.moore@intel.com>, "Len Brown" <lenb@kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: Endless ACPI errors on Linus tree (5b664cb235)
References: <s5hzlof1ll2.wl%tiwai@suse.de>
 <87od4vqvaj.fsf@basil.nowhere.org> <s5htzencp02.wl%tiwai@suse.de>
 <s5hr69rz57u.wl%tiwai@suse.de> <s5hk5fjurag.wl%tiwai@suse.de>
 <4880DE15.76E4.0078.0@novell.com> <s5habgfdu5e.wl%tiwai@suse.de>
 <20080718165814.GF32051@basil.nowhere.org> <s5hmykexm53.wl%tiwai@suse.de>
In-Reply-To: <s5hmykexm53.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > > After someone else observed some problem with this patch earlier, I had
>> > > already sent out attached patch as a replacement one. Any chance you
>> > > could also try this with your box?
>> > 
>> > It resulted in the same error, unfortunately.
>> 
>> Can you send a acpi table dump please?

The situation is even worse here - the (v2) bit width now is divisible by 16,
but still isn't in sync with the v1 field (as is the gpe0 one):

		v1		v2
PM1a_EVT	4		0x10
PM1a_CNT	2		0x10
PM1b_CNT	2		0x10
PM_TMR		4		0x20
GPE0		8		0x20

That would basically mean there's no way to use the v2 fields here - all
the code could do is report the inconsitency, but it would have to use
the v1 field in any case. That's really a shame, and as before I'm
somewhat hesitant to do so. The only way I could easily find myself
doing this would be to introduce a command line option controlling the
behavior here, but that would need to be done outside of the ACPICA
code I'd assume.

Andi, Bob, Len?

Jan

