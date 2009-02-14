Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753AbZBNLnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbZBNLnM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 06:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZBNLm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 06:42:58 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:54429 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227AbZBNLm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 06:42:57 -0500
Message-Id: <1234611775.19975.1300340003@webmail.messagingengine.com>
X-Sasl-Enc: cRTHkq2TD/48D8qw0CMOi6xB5AblEwA/1l5g8/Nb45nB 1234611775
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Jan Beulich" <jbeulich@novell.com>, linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20090213215017.959278111@gmail.com>
 <1234567411.13034.1300286953@webmail.messagingengine.com>
 <49961178.6040101@zytor.com>
Subject: Re: [RFC 0/6] x86 tip asm ENTRY,ENDPROC cleanup
In-Reply-To: <49961178.6040101@zytor.com>
Date: Sat, 14 Feb 2009 12:42:55 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Feb 2009 16:34:00 -0800, "H. Peter Anvin" <hpa@zytor.com>
said:
> Alexander van Heukelum wrote:
> > 
> > Hi Cyrill,
> > 
> > I like this direction. If I understand correctly:
> > 
> > ENTRY/END or GLOBAL/END for data.
> > ENTRY/ENDPROC or GLOBAL/ENDPROC for functions.
> > 
> 
> Fine for functions, but it's really not okay to use the same macros for 
> data.  Furthermore, we need to consider special entry points that don't 
> behave like normal functions -- like system call or interrupt entry.
> 
> Why?  Because if we're compiling with frame pointers, we would like the 
> wrapper macros for functions to handle setting up and tearing down the 
> frame pointer, at least in the common case.

Hi Peter,

I see. But that would be new behaviour. I would propose to use
completely separate macro's to handle frame-setup code generation,
and keep ENTRY/GLOBAL/END/ENDPROC only for setting metadata and
alignment. I think it's worth it to spell out code-generating
macro's explicitly: there are not that many asm functions, and
quite a few of them would need special handling. I think noone
wants to see an ENDPROC_NOFRAMETEARDOWN ;).

The common-case example would look like this.

GLOBAL(c_callable_function)
        ENTER
        [asm-code]
        LEAVE
        ret
ENDPROC(c_callable_function)

Greetings,
    Alexander

> 	-hpa
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - I mean, what is it about a decent email service?

