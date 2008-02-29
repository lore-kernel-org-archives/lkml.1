Return-Path: <linux-kernel-owner+w=401wt.eu-S933003AbYB2W1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbYB2W1B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:27:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbYB2W0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:26:51 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46435 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751021AbYB2W0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:26:51 -0500
Message-Id: <1204324010.2610.1239905639@webmail.messagingengine.com>
X-Sasl-Enc: jRJSlcLlxMClxxdA2XswI5UkijmqbUv5IT43WNScIwFO 1204324010
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Mark McLoughlin" <markmc@redhat.com>
Cc: "Alexander van Heukelum" <heukelum@mailshack.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Ian Campbell" <ijc@hellion.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, "Andi Kleen" <ak@suse.de>,
       "Thomas Gleixner" <tglx@linutronix.de>,
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
   <1204322819.6299.1.camel@muff>
Subject: Re: [PATCH] reserve end-of-conventional-memory to 1MB on 32-bit
In-Reply-To: <1204322819.6299.1.camel@muff>
Date: Fri, 29 Feb 2008 23:26:50 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 22:06:59 +0000, "Mark McLoughlin"
<markmc@redhat.com> said:
> On Fri, 2008-02-29 at 19:38 +0100, Alexander van Heukelum wrote:
> > My first guess is that the BIOS data area is completely non-existent for
> > Xen. Is it guaranteed that the memory is zeroed out on boot?
> 
> Yep, that seems to be the case
> 
> > In that case we can special-case it easily:
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
> 
> Yes, that fixes boot for me.

Thanks for testing this.

I'ld rather not count on Xen providing zeroed memory, though. I'll
try to find a different solution. It's weekend anyhow ;).

Greetings,
    Alexander
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Or how I learned to stop worrying and
                          love email again

