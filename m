Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbZAAHNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbZAAHNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 02:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbZAAHMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 02:12:51 -0500
Received: from gw.goop.org ([64.81.55.164]:46178 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbZAAHMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 02:12:50 -0500
Message-ID: <495C6CE9.3080402@goop.org>
Date: Thu, 01 Jan 2009 18:12:41 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Helge Deller <deller@gmx.de>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Randolph Chung <randolph@tausq.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       John David Anglin <dave@hiauly1.hia.nrc.ca>
Subject: Re: [PATCH] parisc: fix module loading failure of large kernel modules
 (take 4)
References: <4959346E.7060600@gmx.de> <200812310915.41693.rusty@rustcorp.com.au> <495B5806.3080505@gmx.de> <alpine.LFD.2.00.0812310926450.5086@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812310926450.5086@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Some gcc versions will inline weak functions if they are in scope - even 
> if there is a non-weak function somewhere else. So you MUST NOT have the 
> weak definition in the same file (or indirectly called through some inline 
> functions in a header file) as the call. Because if you do, then any user 
> with the wrong version of gcc will get the weak function semantics, even 
> if it was meant to be overridden by something else.
>   

Yes.  I think this behaviour is considered to be desperately broken by 
the gcc developers and has been fixed in all recent gccs.  There are a 
couple of broken versions, and there have been patches floating around 
to just refuse to use them; otherwise __weak is effectively unusable.  
(Ah, I see Adrian has posted it again and everyone agrees with it.)

On the other hand, I have seen a couple of instances of "inline __weak" 
which is insane, but I don't know if gcc does anything crazy with it, or 
if its common enough to bother warning about.

    J
