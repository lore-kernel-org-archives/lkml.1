Return-Path: <linux-kernel-owner+w=401wt.eu-S1761203AbYESTEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761203AbYESTEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 15:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbYESTEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 15:04:01 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:53755 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671AbYESTEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 15:04:00 -0400
Date: Mon, 19 May 2008 21:04:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make LIST_POISON less deadly
Message-ID: <20080519190438.GB24599@uranus.ravnborg.org>
References: <1211125094-32167-1-git-send-email-avi@qumranet.com> <20080519130151.GE13546@elte.hu> <4831845F.6030904@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4831845F.6030904@qumranet.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 04:45:03PM +0300, Avi Kivity wrote:
> Ingo Molnar wrote:
> >i'd suggest to add an ARCH_ILLEGAL_POINTER define instead, which 
> >defaults to zero and gets added to pointer-ish poison values. That makes 
> >it both simpler and also it does not need any include/asm changes 
> >because ARCH_ILLEGAL_POINTER can be set from the Kconfig space.
> >  
> 
> Any idea how to override a value in Kconfig?  We can do it for bool 
> values but not strings.
> 
> e.g.
> 
> lib/Kconfig:
>  config ILLEGAL_POINTER_VALUE
>      hex
>      default 0
> 
> arch/x86/Kconfig:
>  config X86
>    select ILLEGAL_POINTER_VALUE=0x80000000000000000000000000 if X86_64
> 
> ?
> 
> I could do it with a boolean signifying existence and a hex for the 
> value, but I'd rather not.

Sorry - no help here. I have not tried to work that much with int in
Kconfig.

That said I really think stuff like this belongs in a header file.
I do not agree to hide this as part of the configuration.

	Sam
