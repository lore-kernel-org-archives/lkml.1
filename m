Return-Path: <linux-kernel-owner+w=401wt.eu-S1761538AbYB2StU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761538AbYB2StU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758721AbYB2StB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:49:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37993 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759694AbYB2StA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:49:00 -0500
Message-ID: <47C85294.9030902@zytor.com>
Date: Fri, 29 Feb 2008 10:44:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>
CC: Mark McLoughlin <markmc@redhat.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>, Ian Campbell <ijc@hellion.org.uk>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reserve end-of-conventional-memory to 1MB on 32-bit
References: <20080224174605.GA21661@mailshack.com> <47C22568.1010405@zytor.com>   <1203958478.20033.1239002461@webmail.messagingengine.com>   <20080225170134.GA15839@elte.hu>   <20080225180750.GA31054@mailshack.com>   <20080228131341.GA25213@mailshack.com>   <1204232996.28798.8.camel@cthulhu.hellion.org.uk>   <20080229114943.GA1909@mailshack.com> <1204305247.2037.2.camel@muff> <1204310323.24514.1239870063@webmail.messagingengine.com>
In-Reply-To: <1204310323.24514.1239870063@webmail.messagingengine.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> 
> My first guess is that the BIOS data area is completely non-existent for
> Xen.
> Is it guaranteed that the memory is zeroed out on boot? In that case we
> can
> special-case it easily:
> 
> change:
>         /* Paranoia: should never happen, but... */
>         if (lowmem >= 0x100000)
>                 lowmem = 0xa0000;
> 
> into:
>         /* Strange case, like Xen ;) */
>         if (lowmem == 0 || lowmem >= 0x100000)
>                 lowmem = 0x9f000;
> 
> Can you test that?
> 

The EBDA is optional anyway; I presume it should have a zero pointer if 
it isn't present.

	-hpa
