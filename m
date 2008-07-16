Return-Path: <linux-kernel-owner+w=401wt.eu-S1760073AbYGPXzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073AbYGPXzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 19:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758372AbYGPXy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 19:54:59 -0400
Received: from outbound-mail-06.bluehost.com ([69.89.17.206]:49118 "HELO
	outbound-mail-06.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753307AbYGPXy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 19:54:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=EywaKYTi6dxV4bhYPsX91rDjRvr/c+18TO9yy/3rsoJhvkr6pMWeOF+FeDYs85R8IAZe6xzNrJhQfMU0QVqf0E7XgmM1JggqEx5n61m+ynAeM9cEndAwrJSeCoRCtcNv;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] PCI pull request for 2.6.27
Date: Wed, 16 Jul 2008 16:54:55 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <200807161639.24289.jbarnes@virtuousgeek.org> <alpine.LFD.1.10.0807161647470.2835@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807161647470.2835@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807161654.55699.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 16, 2008 4:50 pm Linus Torvalds wrote:
> On Wed, 16 Jul 2008, Jesse Barnes wrote:
> > Miklos Vajna (1):
> >       x86/PCI: janitor work in irq.c
>
> Please don't take patches like this.
>
> If it's janitor work, the end result should be better. But it's not. This
> patch is full of stuff like
>
> -	for(addr = (u8 *) __va(0xf0000); addr < (u8 *) __va(0x100000); addr +=
> 16) { +	for (addr = (u8 *) __va(0xf0000); addr < (u8 *) __va(0x100000);
> +		addr += 16) {
>  		rt = pirq_check_routing_table(addr);
>
> Which just brings negative value. The code is _harder_ to look at, not
> easier.
>
> The 80-character limit is less important than making code look obvious and
> indentation being readable. Splitting the for(;;) loop just made the
> indentation look like total crap.
>
> I'm fixing it up (since it also caused trivial conflicts), but I'd ask
> people to just ignore that sh*t-for-brains that is the long-line warning
> when trying to fix it may silence a warning, but results in worse code!

Yeah I noticed that too when I did the merge (and in the original patch), 
though on my 80 char display it looked like a wash in terms of readability to 
me, but even in that case I should have rejected it as noise.  Sorry about 
that.

Jesse
