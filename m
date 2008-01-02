Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbYABLuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbYABLuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 06:50:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYABLt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 06:49:56 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:52036 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbYABLt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 06:49:56 -0500
Date: Wed, 2 Jan 2008 12:49:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Abdel <draconux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: macro _set_base - "do - while(0)" question
Message-ID: <20080102114956.GB8489@uranus.ravnborg.org>
References: <60d29d630801020345i200a2f72pe860b0d38b530a05@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60d29d630801020345i200a2f72pe860b0d38b530a05@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 12:45:39PM +0100, Abdel wrote:
> Hi,
> 
> In file include/asm-i386/system.h,  _set_base and _set_limit use an
> useless do ... while(0)
> 
> Why is this needed ?
> 
> exemple with _set_base from linux-2.6.23
> 
> #define _set_base(addr,base) do { unsigned long __pr; \
> __asm__ __volatile__ ("movw %%dx,%1\n\t" \
> 	"rorl $16,%%edx\n\t" \
> 	"movb %%dl,%2\n\t" \
> 	"movb %%dh,%3" \
> 	:"=&d" (__pr) \
> 	:"m" (*((addr)+2)), \
> 	 "m" (*((addr)+4)), \
> 	 "m" (*((addr)+7)), \
>          "0" (base) \
>         ); } while(0)
> 
Without the do {} while (0)

then
1) you could not define the variable __pr
2) You would be fooled when you did:

	if (foo != bar)
		set_base(addr,base);


	Sam
