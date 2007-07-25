Return-Path: <linux-kernel-owner+w=401wt.eu-S934628AbXGYRqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934628AbXGYRqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765891AbXGYRqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:46:07 -0400
Received: from gw.goop.org ([64.81.55.164]:47567 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764501AbXGYRqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:46:06 -0400
Message-ID: <46A78C1B.8070509@goop.org>
Date: Wed, 25 Jul 2007 10:44:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, hpa@zytor.com, kaos@ocs.com.au,
       xyzzy@speakeasy.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
References: <21803.1185331847@ocs10w.ocs.com.au> <46A6DB04.3000003@zytor.com> <46A6ECB7.7090208@goop.org> <20070724.232914.56812376.davem@davemloft.net> <alpine.LFD.0.999.0707250954400.3607@woody.linux-foundation.org> <20070725173646.GI27237@ftp.linux.org.uk>
In-Reply-To: <20070725173646.GI27237@ftp.linux.org.uk>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Wed, Jul 25, 2007 at 09:56:12AM -0700, Linus Torvalds wrote:
>   
>> We don't just do the "ud2" instruction - we also do the file and line 
>> number information after it. Which means that __builtin_trap() is useless.
>>
>> So we might as well keep the loop, since both are two-byte instructions 
>> that tell gcc that it will never continue.
>>     
>
> Actually, the worse problem is that gcc will happily merge these guys.
> And that's a killer.
>   

Merge __builtin_traps()?  Ugh.  But also, there's no real long-term
guarantee that it will keep generating ud2a.  The *only* mention of it
in the manual is a discussion that it will emit a call to abort() on
arches which don't otherwise support it.

    J
