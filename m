Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbYKQTng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbYKQTng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbYKQTn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:43:28 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44733 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751760AbYKQTn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:43:27 -0500
Message-Id: <1226951006.21581.1285268501@webmail.messagingengine.com>
X-Sasl-Enc: miKpvuoRtIb839Pju62XFX/0CquxEuYFsn0UOrqlAdiL 1226951006
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>, "Andi Kleen" <andi@firstfloor.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "LKML" <linux-kernel@vger.kernel.org>,
       "Alexander van Heukelum" <heukelum@lusi.uni-sb.de>,
       "Glauber Costa" <gcosta@redhat.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1226845741-12470-1-git-send-email-heukelum@fastmail.fm>
 <1226845741-12470-2-git-send-email-heukelum@fastmail.fm>
 <20081117125317.GK6703@one.firstfloor.org>
 <1226936257.32609.1285214311@webmail.messagingengine.com>
 <20081117182340.GN6703@one.firstfloor.org>
 <20081117192216.GA9944@localhost>
Subject: Re: [RFC] x86: save_args out of line
In-Reply-To: <20081117192216.GA9944@localhost>
Date: Mon, 17 Nov 2008 20:43:26 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008 22:22:16 +0300, "Cyrill Gorcunov"
<gorcunov@gmail.com> said:
> [Andi Kleen - Mon, Nov 17, 2008 at 07:23:40PM +0100]
> ...
> | 
> | Ok. Hopefully it's worth the effort. The branch misprediction bubble
> | should not be too bad, perhaps it'll make up for the other cycles
> | you're adding. But even if it doesn't decreasing cache line foot print
> is 
> | always a good thing.
> ...
> 
> May I turn in? :)

Sure!

> Original .macro interrupt func has
> 
> 	testl $3, CS(%rdi)
> 	je 1f
> 	SWAPGS
> 1:	incl %gs:pda_irqcount

inc changes flags...

> 	jne 2f
> 	pop %rax
> 	mov %gs:pda_irqstackptr,%rsp
> 	push %rax
> 2:	TRACE_IRQS_OFF
> 
> Wouldn't we help the branch predictor a bit by
> 
> 	testl $3, CS(%rdi)
> 	je 1f
> 	SWAPGS
> 	jne 2f

... so this is not the same.

> 1:	pop %rax
> 	mov %gs:pda_irqstackptr,%rsp
> 	push %rax	
> 2:	incl %gs:pda_irqcount
> 	TRACE_IRQS_OFF
> 
> I hope I didn't miss anything but maybe it's just a churning
> or plain wrong. Don't shoot me :)

I'm sure it helps the branch predictor, though ;).

Alexander

> 		- Cyrill -
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - A fast, anti-spam email service.

