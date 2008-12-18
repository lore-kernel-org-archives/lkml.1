Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753409AbYLRMf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbYLRMf3 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 07:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYLRMfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 07:35:06 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55456 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752862AbYLRMfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 07:35:04 -0500
Message-Id: <1229603702.27623.1290725827@webmail.messagingengine.com>
X-Sasl-Enc: tMS9W1sVEbJhw+uh5kb0AG7zehsaAS+4v1i869piYN/i 1229603702
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Russell King" <rmk+lkml@arm.linux.org.uk>,
        "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: "David Howells" <dhowells@redhat.com>, linux-arch@vger.kernel.org,
        "Ingo Molnar" <mingo@elte.hu>, "LKML" <linux-kernel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Sam Ravnborg" <sam@ravnborg.org>,
        "Cyrill Gorcunov" <gorcunov@gmail.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm>
 <1636.1229511233@redhat.com> <20081217111213.GA8342@mailshack.com>
 <20081218114427.GD10593@flint.arm.linux.org.uk>
Subject: Re: PROC macro to annotate functions in assembly files
In-Reply-To: <20081218114427.GD10593@flint.arm.linux.org.uk>
Date: Thu, 18 Dec 2008 13:35:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008 11:44:27 +0000, "Russell King"
<rmk+lkml@arm.linux.org.uk> said:
> On Wed, Dec 17, 2008 at 12:12:14PM +0100, Alexander van Heukelum wrote:
> > Yeah, assembly files contain some interesting nesting. In this
> > particular case I think the solution is simple... Just use PROC
> > and ENDPROC around the complete functions, and leave the explicit
> > .global's for the additional entry points.
> 
> I'm sorry, that doesn't work in all cases.
> 
> On ARM with later toolchains, there's additional metadata associated with
> every symbol, and it's beginning to matter getting this right.  That
> metadata includes whether it's a function, and more importantly whether
> the code pointed to by the symbol is Thumb or ARM.
> 
> This leads to:
> 
> ENTRY(__ashldi3)
> ENTRY(__aeabi_llsl)
> 
> ...
> 
> ENDPROC(__ashldi3)
> ENDPROC(__aeabi_llsl)
> 
> and we want both of those symbols to have exactly the same attributes.
> 
> Merely adding a .globl for the second name doesn't do that.  It needs
> .globl, .size, and .type.
> 
> So what you're actually talking about using your approach is enforcing
> the pairing of the existing ENTRY/ENDPROC and open coding everything
> else.

Note that enforcing the pairing will be enabled by ARCH code. Is the
construct you show here (two symbols covering identical code) the only
problem you forsee? I don't want to introduce too many macro's to
handle special cases, but this one should be solved.

> Forgive me if I think this is a backward step.  It certainly seems to
> add some insane restrictions.

Some restrictions are introduced, indeed. And I agree that evading the
checking framework by doing things manually should be avoided.

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
http://www.fastmail.fm - The way an email service should be

