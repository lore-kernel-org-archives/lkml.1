Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbYGZRAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbYGZRAu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 13:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYGZRAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 13:00:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:1519 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbYGZRAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 13:00:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=P5+K107BBcJgEj4IguoDxb9235Ri8JbOjmheYdc4pPjeoCwgTeq6AMqSIddIkumUQc
         6MPs37POtmoxZKzjv8IS+PR5nAhQjEcnXuLs6DkEqsUq+ZHj5vYNww++w4D34gfDH7d/
         feWlioIA/YmBQYpNGNXwX16zjoEzrVRhHMw4g=
Subject: Re: Fw: asm-x86/byteorder.h, CONFIG_X86_BSWAP leaks to userland
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Olaf Hering <olaf@aepfle.de>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <488B555F.4090709@zytor.com>
References: <20080726013931.bcc4682d.akpm@linux-foundation.org>
	 <1217090446.5971.57.camel@brick>  <488B555F.4090709@zytor.com>
Content-Type: text/plain
Date: Sat, 26 Jul 2008 10:00:37 -0700
Message-Id: <1217091637.5971.63.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-26 at 12:48 -0400, H. Peter Anvin wrote:
> Harvey Harrison wrote:
> >>
> >> An undefined CONFIG_foo defaults to 0 (I think), so bswap is never used.
> >> Is this done on purpose, or can the CONFIG_ foo be moved inside
> >> __KERNEL__ somehow?
> > 
> > I believe it's there to prevent the bswap instruction from being used on
> > early x86_32 models (i386/i486).  As this will be 0 in userspace it is
> > effectively never using the bswap instruction for these routines.
> > 
> 
> i386, specifically.
> 
> However, you shouldn't leak these symbols to userspace; there is a 
> warning option in gcc for undefined macros, and it's a *good thing* to 
> use it.  Causing warnings in user space is not nice.

True, but the existing header in Linus' tree does exactly this, so unless
you beat me to it, I'll have a look to see what can be done here.

> 
> > I'm not sure if it's time yet to make the bswap ones be exported, as they
> > would no longer be usable for those early machines.  X86 guys CC:d.
> 
> On i386 we still default to i386-compatible binaries; I *think* gcc has 
> macros telling you if the user has used -march=i486 etc.
> 

Hmm, I wasn't aware of that, hopefully google will oblige.

Cheers,

Harvey

