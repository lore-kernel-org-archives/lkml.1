Return-Path: <linux-kernel-owner+w=401wt.eu-S1758427AbYDNMYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427AbYDNMYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 08:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbYDNMYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 08:24:08 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45833 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753320AbYDNMYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 08:24:06 -0400
Message-Id: <1208175845.22460.1247749229@webmail.messagingengine.com>
X-Sasl-Enc: +AgqkBBM7fTpINczPb3N2eAixeclQ2m4xMNmqScQeN+/ 1208175845
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "Alexander van Heukelum" <heukelum@mailshack.com>,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080413112308.GA23426@mailshack.com>
   <87hce5wv2h.fsf@basil.nowhere.org>
   <1208109831.1489.1247631595@webmail.messagingengine.com>
   <20080413181642.GA8641@one.firstfloor.org>
Subject: Re: [PATCH] x86: always_inline wrapper for x86's test_bit
In-Reply-To: <20080413181642.GA8641@one.firstfloor.org>
Date: Mon, 14 Apr 2008 14:24:05 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 20:16:42 +0200, "Andi Kleen" <andi@firstfloor.org>
said:
> > I have googled, but the only problem I found was concerning dead code 
> 
> It might come as a surprise, but google is still not omniscient.

Hi,

It's just not always easy to think of the right question to ask the
oracle ;).

> > elimination, and in particular references to unavailable object from
> > code that was expected to be discarded. The worst that can happen in 
> > this case is that gcc might produce a strange construction where a
> > runtime check will choose between the two alternative implementations of
> > test_bit. Another is that it will select the 'wrong' implementation. 
> > Both will result is some code-bloat, but at least the code should work
> > properly.
> 
> Yes, but extreme code bloat can be fatal.
> 
> > I have not checked with 3.2. The oldest compiler I have available here
> > is 3.3. That version compiles the functions as expected: I have found
> > instances of either type in the objdump and I have not found strange
> > constructions with both types there.
> 
> It would be good to check on 3.2 too to avoid potential nasty surprises.

Checked with a stock 3.2.3 form gcc.gnu.org (compiled using debian's
gcc-2.95). It gets it right: places that should get the C version get
the C version and places that should get the inline-assembly version
get the inline-assembly version. No funny things at all.

B.T.W., debian and ubuntu don't provide gcc-3.2 packages. Is there a
good reason why gcc-3.2.3 (5 years old in a week) should still be
supported?

> > If you were thinking of another/bigger problem with gcc-3.2, could you 
> > please give me a pointer?
> 
> Not sure what you mean here.

I just thought you might have been thinking of a specific problem. A
bug-report or something like that would have been convenient to have.
Looking for a problem is easier than looking for no problems ;).

Greetings,
    Alexander

> -Andi
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Does exactly what it says on the tin

