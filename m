Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbYKDSHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbYKDSHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYKDSHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:07:06 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:60388 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543AbYKDSHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:07:04 -0500
Message-Id: <1225822006.21441.1282961299@webmail.messagingengine.com>
X-Sasl-Enc: bXtuxm9+CXclAEK1gvFiuoB+PZiYbz97+TiDY+KxQ/Cb 1225822006
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Andi Kleen" <andi@firstfloor.org>, "Cyrill Gorcunov" <gorcunov@gmail.com>
Cc: "Alexander van Heukelum" <heukelum@mailshack.com>,
       "LKML" <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, lguest@ozlabs.org,
       jeremy@xensource.com, "Steven Rostedt" <srostedt@redhat.com>,
       "Mike Travis" <travis@sgi.com>, "Andi Kleen" <andi@firstfloor.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20081104122839.GA22864@mailshack.com> 
 <20081104150729.GC21470@localhost> 
 <20081104170501.GE29626@one.firstfloor.org>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
In-Reply-To: <20081104170501.GE29626@one.firstfloor.org>
Date: Tue, 04 Nov 2008 19:06:46 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008 18:05:01 +0100, "Andi Kleen" <andi@firstfloor.org>
said:
> > not taking into account the cost of cs reading (which I
> > don't suspect to be that expensive apart from writting,
> 
> GDT accesses have an implied LOCK prefix. Especially
> on some older CPUs that could be slow.
> 
> I don't know if it's a problem or not but it would need
> some careful benchmarking on different systems to make sure interrupt 
> latencies are not impacted.

That's good to know. I assume this LOCKed bus cycle only occurs
if the (hidden) segment information is not cached in some way?
How many segments are typically cached? In particular, does it
optimize switching between two segments?

> Another reason I would be also careful with this patch is that
> it will likely trigger slow paths in JITs like qemu/vmware/etc.

Software can be fixed ;).

> Also code segment switching is likely not something that
> current and future micro architectures will spend a lot of time
> optimizing.
> 
> I'm not sure that risk is worth the small improvement in code
> size.

I think it is worth exploring a bit more. I feel it should be
a neutral change worst-case performance-wise, but I really
think the new code is more readable/understandable.

> An alternative BTW to having all the stubs in the executable
> would be to just dynamically generate them when the interrupt
> is set up. Then you would only have the stubs around for the 
> interrupts which are actually used.

I was trying to simplify things, not make it even less
transparent ;).

> -Andi
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - A no graphics, no pop-ups email service

