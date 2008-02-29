Return-Path: <linux-kernel-owner+w=401wt.eu-S933519AbYB2S5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933519AbYB2S5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:57:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760939AbYB2S4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:56:55 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40246 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758161AbYB2S4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:56:54 -0500
Message-Id: <1204311412.28554.1239873349@webmail.messagingengine.com>
X-Sasl-Enc: K8EyqEwKdtpSOjc+SAYjsuTe69DMPJCZvj8g3tPtaIkm 1204311412
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Mark McLoughlin" <markmc@redhat.com>,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Ian Campbell" <ijc@hellion.org.uk>,
       "Andi Kleen" <ak@suse.de>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080224174605.GA21661@mailshack.com> <47C22568.1010405@zytor.com>
   <1203958478.20033.1239002461@webmail.messagingengine.com>
   <20080225170134.GA15839@elte.hu>
   <20080225180750.GA31054@mailshack.com>
   <20080228131341.GA25213@mailshack.com>
   <1204232996.28798.8.camel@cthulhu.hellion.org.uk>
   <20080229114943.GA1909@mailshack.com> <1204305247.2037.2.camel@muff>
   <1204310323.24514.1239870063@webmail.messagingengine.com>
   <47C85294.9030902@zytor.com>
Subject: Re: [PATCH] reserve end-of-conventional-memory to 1MB on 32-bit
In-Reply-To: <47C85294.9030902@zytor.com>
Date: Fri, 29 Feb 2008 19:56:52 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 29 Feb 2008 10:44:36 -0800, "H. Peter Anvin" <hpa@zytor.com>
said:
> Alexander van Heukelum wrote:
> > 
> > My first guess is that the BIOS data area is completely non-existent for
> > Xen.
> > Is it guaranteed that the memory is zeroed out on boot? In that case we
> > can
> > special-case it easily:
> > 
> > change:
> >         /* Paranoia: should never happen, but... */
> >         if (lowmem >= 0x100000)
> >                 lowmem = 0xa0000;
> > 
> > into:
> >         /* Strange case, like Xen ;) */
> >         if (lowmem == 0 || lowmem >= 0x100000)
> >                 lowmem = 0x9f000;
> > 
> > Can you test that?
> > 
> 
> The EBDA is optional anyway; I presume it should have a zero pointer if 
> it isn't present.

Correct, but the value that indicates the size of the conventional
memory
area must be set. At least on any real hardware. My guess is that both
values read as 0 on Xen, which causes 0-0x100000 to be reserved. If that
is always the case the workaround is fine, I think.

Alexander

> 	-hpa
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - mmm... Fastmail...

