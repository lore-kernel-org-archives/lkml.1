Return-Path: <linux-kernel-owner+w=401wt.eu-S1762260AbYEXVPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762260AbYEXVPs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759391AbYEXVPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:15:41 -0400
Received: from gw.goop.org ([64.81.55.164]:53767 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758220AbYEXVPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:15:40 -0400
Message-ID: <4838855F.2090701@goop.org>
Date: Sat, 24 May 2008 22:15:11 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Tom Spink <tspink@gmail.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Steve French <smfrench@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com>	 <4837AAE2.9090102@zytor.com>	 <20080524064201.GA4133@uranus.ravnborg.org>	 <4837E89D.9040008@goop.org>	 <20080524112704.GA7292@uranus.ravnborg.org>	 <483827CE.9080200@goop.org>	 <20080524153611.GA13890@uranus.ravnborg.org>	 <48383830.6060504@goop.org>	 <19f34abd0805240857l57e667fdicb240baf898f6296@mail.gmail.com>	 <48383C26.5040106@goop.org> <7b9198260805240940v46db928ak9bcacf9363c46d41@mail.gmail.com> <48387CCB.1030801@goop.org> <48387DF0.7000600@zytor.com> <48387FE7.2080608@goop.org> <48388097.3060707@zytor.com>
In-Reply-To: <48388097.3060707@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> That's a very defeatist stance, and quite frankly bogus.

But <stamp foot> coding is *hard*.

> Doing it as a flag day event is not really practical, which is why we 
> need a new set of symbols.  However, at that point we can discourage 
> continuing use of the CONFIG_ symbols and deprecate them over time. 
> It's not like we're talking about user-space-visible interfaces here!

Well, I'm thinking more along the lines of:

   1. We introduce this <whatever> mechanism
   2. Hundreds of people pop out of the woodwork thinking "this looks
      more fun than tweaking whitespace"
   3. They produce one-hundred trillion "convert #ifdef to if()" patches
   4. We have one-hundred trillion^2 followup "fix build with this
      .config" patches

3 might be enough to finally drive Andrew out of the kernel business, 
but 4 definitely would be.

The whole point is to try and get config-invariant build breakages, so 
that we become less dependent on lots of randconfig testing.  If the 
definedness of the KCONFIG_ constants is still dependent on a particular 
.config, then we're not really making all that much progress.

If we move to having a single unified kernel config rather than per-arch 
ones (as Sam mentioned), then we can be sure of generating a complete 
list of all config variables, and we can explicitly define them.  But if 
we don't move to that state more or less simultaneously with using 
KCONFIG_ constants, then we should do it in the defeatest way so we can 
make forward progress with minimal regression.

    J
