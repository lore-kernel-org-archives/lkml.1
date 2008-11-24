Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbYKXKfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbYKXKfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 05:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYKXKfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 05:35:05 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:52958 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYKXKfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 05:35:04 -0500
Message-Id: <492A9199.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Mon, 24 Nov 2008 10:35:53 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Cyrill Gorcunov" <gorcunov@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Glauber Costa" <gcosta@redhat.com>, "Matt Mackall" <mpm@selenic.com>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: KPROBE_ENTRY should be paired wth KPROBE_END
References: <20081120150412.GC13550@elte.hu>
 <20081120152601.GA3953@mailshack.com> <20081120153954.GA22511@elte.hu>
 <20081121154155.GA12999@mailshack.com>
 <20081121154318.GA13014@mailshack.com>
 <20081121154428.GB13014@mailshack.com> <20081121160629.GA24839@elte.hu>
 <20081123090828.GA31490@mailshack.com>
 <20081123091532.GA31515@mailshack.com> <492A7F39.76E4.0078.0@novell.com>
 <20081124102600.GA8335@mailshack.com>
In-Reply-To: <20081124102600.GA8335@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Right. I thought of END and ENDPROC as equivalent, so I added the change
>to this patch as a small cleanup only. But if we want this .type
>annotation, what about KPROBE_END? should it include one there too?

Yes, it always bothered me that there's no KPROBE_ENDPROC() (or
alternatively, as this being code is implied by the macro, it didn't do the
annotation by default).

>I'm getting a feeling we would be better off removing KPROBE_ENTRY and
>KPROBE_END if favour of explicitly changing sections in the .S files?
>And using the ENDPROC annotation for all procedures?

It got explicitly added a while back, so there must have been a reason to
*not* do the section adjustments explicitly. And given the current discussion
I'd also assume that more hiding of code in macros is the preferred route.

Jan

