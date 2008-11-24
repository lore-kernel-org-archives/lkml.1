Return-Path: <linux-kernel-owner+w=401wt.eu-S1752416AbYKXJQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbYKXJQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYKXJQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:16:45 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:48013 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbYKXJQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:16:45 -0500
Message-Id: <492A7F39.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Mon, 24 Nov 2008 09:17:29 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, "Cyrill Gorcunov" <gorcunov@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Glauber Costa" <gcosta@redhat.com>, "Matt Mackall" <mpm@selenic.com>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: KPROBE_ENTRY should be paired wth KPROBE_END
References: <20081119001811.GA23237@mailshack.com>
 <20081120134011.GA3627@mailshack.com> <20081120150412.GC13550@elte.hu>
 <20081120152601.GA3953@mailshack.com> <20081120153954.GA22511@elte.hu>
 <20081121154155.GA12999@mailshack.com>
 <20081121154318.GA13014@mailshack.com>
 <20081121154428.GB13014@mailshack.com> <20081121160629.GA24839@elte.hu>
 <20081123090828.GA31490@mailshack.com>
 <20081123091532.GA31515@mailshack.com>
In-Reply-To: <20081123091532.GA31515@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Alexander van Heukelum <heukelum@mailshack.com> 23.11.08 10:15 >>>
>@@ -1282,7 +1282,7 @@ gs_change:
> 	CFI_ADJUST_CFA_OFFSET -8
>         ret
> 	CFI_ENDPROC
>-ENDPROC(native_load_gs_index)
>+END(native_load_gs_index)
> 
>         .section __ex_table,"a"
>         .align 8

I disagree to this and similar changes in this patch: Why do we need to
get rid of the ENDPROC() here? It's a procedure that's being ended, and
using ENDPROC() is the only (existing) way to mark something as a
procedure in assembly code.

And btw., while described so in the patch comment, this change has nothing
to do with the subject of the patch.

Jan

