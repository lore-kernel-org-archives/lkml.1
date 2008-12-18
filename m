Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752709AbYLRLbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbYLRLbP (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 06:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYLRLa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 06:30:56 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55744 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968AbYLRLaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 06:30:55 -0500
Message-Id: <1229599844.16633.1290718265@webmail.messagingengine.com>
X-Sasl-Enc: YeyqCvKLebBr4rIqrJdj3XupocOBKsbFI/fCwZeXMAvX 1229599844
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Russell King" <rmk+lkml@arm.linux.org.uk>
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Cyrill Gorcunov" <gorcunov@gmail.com>,
        "Jan Beulich" <jbeulich@novell.com>, linux-arch@vger.kernel.org,
        "Alexander van Heukelum" <heukelum@mailshack.com>,
        "Ingo Molnar" <mingo@elte.hu>, "LKML" <linux-kernel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm>
 <1229505475-10219-2-git-send-email-heukelum@fastmail.fm>
 <20081217172640.GB5436@uranus.ravnborg.org>
 <20081217173824.GF8078@localhost>
 <20081217180023.GA5783@uranus.ravnborg.org>
 <1229593918.31758.1290707307@webmail.messagingengine.com>
 <20081218100747.GA10593@flint.arm.linux.org.uk>
Subject: Re: [PATCH 1/many] PROC macro to annotate functions in assembly files
In-Reply-To: <20081218100747.GA10593@flint.arm.linux.org.uk>
Date: Thu, 18 Dec 2008 12:30:44 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008 10:07:47 +0000, "Russell King"
<rmk+lkml@arm.linux.org.uk> said:
> On Thu, Dec 18, 2008 at 10:51:58AM +0100, Alexander van Heukelum wrote:
> > Agreed. I vote to complement the existing ENDPROC annotation with
> > the proposed PROC annotation. Let's call that an extension, not
> > something new ;). As it stands it is not impossible to go with
> > ENTRY/ENDPROC for code and ENTRY/END for data. However, ENTRY
> > implies alignment and the prefered alignment for code and data
> > might differ.
> 
> Have you looked at the number of ENTRY uses for code vs for data?
> If all you're after is separating the two uses, then it might be a
> smaller patch to change the ENTRY use for data rather than changing
> all the ENTRY uses for code.
> 
> There are 589 uses of ENTRY in arch/arm/*/*.S.  Of those about 50
> aren't called code.

Hi,

Things are similar for x86, but I didn't consider it a problem.

The alternative I see is to is to introduce DATAENTRY and DATAEND
for use with data objects in generic code, equal to ENTRY/END. Then
deprecate the use of ENDPROC, so we can try to get rid of it in the
long run.

Minor nit is that all archs need to override ENTRY and/or END to
include an assembly directive that indicates that the symbol is
a function. Changing this in generic code is not possible as long
as there are ARCHs which have not been converted.

ENDPROC might stick for a very long time, though.

Greetings,
    Alexander

> -- 
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - A fast, anti-spam email service.

