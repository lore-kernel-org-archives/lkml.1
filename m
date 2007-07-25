Return-Path: <linux-kernel-owner+w=401wt.eu-S933265AbXGYRBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265AbXGYRBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757828AbXGYRB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:01:26 -0400
Received: from gw.goop.org ([64.81.55.164]:47969 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721AbXGYRBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:01:25 -0400
Message-ID: <46A781A4.40103@goop.org>
Date: Wed, 25 Jul 2007 10:00:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, hpa@zytor.com, kaos@ocs.com.au,
       xyzzy@speakeasy.org, viro@ftp.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
References: <21803.1185331847@ocs10w.ocs.com.au> <46A6DB04.3000003@zytor.com> <46A6ECB7.7090208@goop.org> <20070724.232914.56812376.davem@davemloft.net> <alpine.LFD.0.999.0707250954400.3607@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707250954400.3607@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> .. and I'm pretty sure it's immaterial.
>
> We don't just do the "ud2" instruction - we also do the file and line 
> number information after it. Which means that __builtin_trap() is useless.
>   

No, not any more.  The file and line info is out of line, in a separate
section, indexed by the ud2a's eip.  The main problem with
__builtin_trap is that there's no certain way to get the actual ud2a eip
(ie, paste an asm label onto it).

    J
