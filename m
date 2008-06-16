Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbYFPWwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbYFPWwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 18:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYFPWwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 18:52:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37299 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbYFPWwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 18:52:07 -0400
Message-ID: <4856EDD3.4080808@kernel.org>
Date: Mon, 16 Jun 2008 15:48:51 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make asm/asm.h work for asm code.
References: <4856E3D3.2010207@goop.org>
In-Reply-To: <4856E3D3.2010207@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> This is useful for unifying some pieces of asm code.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Thinking about it some more, this should be possible to do cleaner like 
this:

#ifdef CONFIG_X86_32
# ifdef __ASSEMBLY__
#  define __ASM_SEL(a,b) a
# else
#  define __ASM_SEL(a,b) " " #a " "
# endif
#else
# ifdef __ASSEMBLY__
#  define __ASM_SEL(a,b) b
# else
#  define __ASM_SEL(a,b) " " #b " "
# endif
#endif

#define _ASM_INC    _ASM_SEL(incl,incq)
#define _ASM_DEC    _ASM_SEL(decl,decq)

/* ... etc ... */
