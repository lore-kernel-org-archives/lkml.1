Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbYFHUU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbYFHUU6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 16:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbYFHUUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 16:20:50 -0400
Received: from wsip-70-184-212-2.om.om.cox.net ([70.184.212.2]:43982 "EHLO
	hachi.dashjr.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbYFHUUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 16:20:49 -0400
From: Luke -Jr <luke@dashjr.org>
Organization: -Jr Family
To: "Kevin D. Kissell" <kevink@mips.com>
Subject: Re: bcm33xx port
Date: Sun, 8 Jun 2008 15:20:38 -0500
User-Agent: KMail/1.9.9
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org
References: <200806072113.26433.luke@dashjr.org> <200806081357.02601.luke@dashjr.org> <484C38A6.7080503@mips.com>
In-Reply-To: <484C38A6.7080503@mips.com>
PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
Jabber-ID: luke@dashjr.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806081520.43090.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 June 2008, Kevin D. Kissell wrote:
> Luke -Jr wrote:
> > On Sunday 08 June 2008, Kevin D. Kissell wrote:
> >> and (b) control being transferred to a block of memory that isn't
> >> actually code, as can happen if exception vectors or global
> >> pointers-to-functions aren't set up correctly, or if the kernel stack is
> >> being corrupted.   When you say "the instruction in question is a store
> >> word", how do you know that?
> >
> > The RI error spits out a bunch of info, including epc which presumably
> > points to the instruction causing the problem: ac85ffc0; this is 'sw
> > a1,-64(a0)'
>
> But unless the processor itself is actually defective, there is no way that
> a  SW instruction can cause an RI exception. Sometimes a kernel crash 
> is so violent that the kernel stack frame cannot be reliably decoded by
> the crash dump code, and this would appear to be one of those cases.

In that case, wouldn't the "kernel stack" appear to be complete nonsense?
Yet the stack in this case is quite logical and consistent. Furthermore, if I 
skip the bzero stuff (by commenting out the call), it will crash shortly 
thereafter when the ELF loader attempts to write to it in another way.
Is it very unlikely that the bcm3345 is simply raising the wrong exception (or 
perhaps Linux is misinterpreting the exception)?

> I find the address of 0xac85ffc0 to be a bit suspicious, myself.  That's
> a kseg1 (non-cacheable identity map) address for physical address
> 0x0c85ffc0, which would be legitimate (though suspicious) if you had
> 256MB of RAM, but the boot log quote you posted earlier suggests
> that you've only got 16M.  Is there really memory of some kind at
> that address?  Are you calling routines in a boot ROM from Linux?

ac85ffc0 is the instruction for 'sw a1,-64(a0)', not an address.
The board has only 8 MB RAM, to the best I can tell from looking up the RAM 
chip (hynix KOREA HY57V641620HG 0229A T-7).

> Debugging Linux kernel crashes is probably not the best way to learn
> the MIPS privileged resource architecture.  I'd strongly recommend
> http://www.amazon.com/See-MIPS-Second-Dominic-Sweetman/dp/0120884216/

Can you recommend any gratis materials to read? I don't have room in my budget 
to spend money on this hobby right now..

Luke
