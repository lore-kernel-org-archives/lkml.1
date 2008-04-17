Return-Path: <linux-kernel-owner+w=401wt.eu-S935162AbYDQKJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935162AbYDQKJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934510AbYDQKGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 06:06:37 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37665 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764845AbYDQKGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 06:06:34 -0400
Message-Id: <1208426793.10305.1248377703@webmail.messagingengine.com>
X-Sasl-Enc: wq4t9ndhwgpKrEtA2h+yA3/B2cS2QumDAKhFWl7vP99o 1208426793
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080416202338.GA6007@elte.hu> <878wzdikwk.fsf@basil.nowhere.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
In-Reply-To: <878wzdikwk.fsf@basil.nowhere.org>
Date: Thu, 17 Apr 2008 12:06:33 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 16 Apr 2008 22:50:51 +0200, "Andi Kleen" <andi@firstfloor.org>
said:
> Ingo Molnar <mingo@elte.hu> writes:
> 
> >  - generalized bitops - they are faster and smaller.
> 
> Faster in a 100% bogus benchmark with the most unrealistic input data
> set one can imagine with some effort. They might be faster or they
> might be slower, nobody really knows currently.

Hello Andi, Ingo,

The input for the first 'benchmark' was indeed completely unrealistic.
They did show a very convincing speedup, though. This program was
really written to verify the implementation and was later converted
to a benchmark. Many benchmarks are unrealistic. I also wrote a
benchmark for find_first_bit and find_next_bit:
        http://heukelum.fastmail.fm/find_first_bit

My conclusion would be: the speed of the generic bitmap implementation
is either better than or at least comparable to the current private
implementations in i386/x86_64. The generic version is out-of-line,
while the private implementation of i386 was inlined: this causes a
regression for very small bitmaps. However, if the bitmap size is
a constant and fits a long integer, the updated generic code should
inline an optimized version, like x86_64 currently does it.

I think the change is a good one.

Greetings,
    Alexander
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - The professional email service

