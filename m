Return-Path: <linux-kernel-owner+w=401wt.eu-S1762238AbYDNQss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762238AbYDNQss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbYDNQsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:48:40 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41918 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754418AbYDNQsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:48:40 -0400
Message-Id: <1208191719.12568.1247788911@webmail.messagingengine.com>
X-Sasl-Enc: OUZXSQmMDePPjfRVYILPSO/HtflW5qHAeAHm/6wX1zYc 1208191719
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
Subject: Re: x86: ppc fixes for find_first_bit
Date: Mon, 14 Apr 2008 18:48:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

I see Ingo has applied three fixes to the x86-tree:
    find_first_bit() ppc fix
    powerpc: fix powerpc build
    find_next_bit() fix

Could you please give some insight in what went wrong with
ppc and powerpc?

"find_first_bit() ppc fix" disables the use of find_first_bit
for every user of GENERIC_FIND_NEXT_BIT=y. It replaces it by a
macro to call find_next_bit with offset=0. It should be possible
for an arch to use GENERIC_FIND_NEXT_BIT=y and implement 
find_first_bit by itself.

"powerpc: fix powerpc build" removes the private 'implementation'
of asm-generic/bitops/find.h. It seems correct code to me. What
was the problem here? If it is duplicate declarations, then
I would suggest putting #ifndef GENERIC_FIND_NEXT_BIT around
them.

"find_next_bit() fix" changes asm-generic/bitops/find.h to
declare find_next_bit only if CONFIG_GENERIC_FIND_NEXT_BIT=n.
That is indeed a good change. It would be better if this
file disappeared completely, though.

Greetings,
    Alexander
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - One of many happy users:
  http://www.fastmail.fm/docs/quotes.html

