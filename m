Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948AbYDMSEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbYDMSEA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYDMSDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:03:53 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54574 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751842AbYDMSDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:03:52 -0400
Message-Id: <1208109831.1489.1247631595@webmail.messagingengine.com>
X-Sasl-Enc: JlnYBVSTK/wbSGp+2zRjULuVRdRjAAQkO10Rfbuc0+/q 1208109831
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Andi Kleen" <andi@firstfloor.org>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080413112308.GA23426@mailshack.com>
   <87hce5wv2h.fsf@basil.nowhere.org>
Subject: Re: [PATCH] x86: always_inline wrapper for x86's test_bit
In-Reply-To: <87hce5wv2h.fsf@basil.nowhere.org>
Date: Sun, 13 Apr 2008 20:03:51 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 18:58:30 +0200, "Andi Kleen" <andi@firstfloor.org>
said:
> Alexander van Heukelum <heukelum@mailshack.com> writes:
> 
> > On x86, test_bit is currently implemented as a preprocessor macro. It
> > uses gcc's __builtin_constant_p to determine if the bit position is 
> > known at compile time and defers to one of two functions depending
> > on that. This changes the same logic to an __always_inline wrapper
> > instead.
> 
> Some old gccs didn't support __builtin_constant_p in inline properly,
> that is why it was always written in macros.
> 
> Please double check with the oldest still supported gcc (3.2) if it 
> really generates the expected code for the constant/non constant case.

Hi Andi,

I have googled, but the only problem I found was concerning dead code 
elimination, and in particular references to unavailable object from
code that was expected to be discarded. The worst that can happen in 
this case is that gcc might produce a strange construction where a
runtime check will choose between the two alternative implementations of
test_bit. Another is that it will select the 'wrong' implementation. 
Both will result is some code-bloat, but at least the code should work
properly.

I have not checked with 3.2. The oldest compiler I have available here
is 3.3. That version compiles the functions as expected: I have found
instances of either type in the objdump and I have not found strange
constructions with both types there.

If you were thinking of another/bigger problem with gcc-3.2, could you 
please give me a pointer?

Greetings,
        Alexander

> -Andi
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Or how I learned to stop worrying and
                          love email again

