Return-Path: <linux-kernel-owner+w=401wt.eu-S1422808AbXBHXM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422808AbXBHXM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 18:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422921AbXBHXM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 18:12:29 -0500
Received: from smtp-out.google.com ([216.239.45.13]:12523 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422808AbXBHXM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 18:12:28 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=X/CuxAF59yPBpaKjpHOH8pKjikrW2P9JysAXPzR4i8hq6JNWzLTxGkJMlIqxjLIFu
	K2pogVf/Y6vrup8Ao36JA==
Date: Thu, 8 Feb 2007 15:12:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <Pine.LNX.4.64.0702081324090.8424@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702081432320.27603@chino.kir.corp.google.com>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702082202180.24888@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081324090.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007, Linus Torvalds wrote:

> Same goes for
> 
> 	struct dummy {
> 		int flag:1;
> 	} a_variable;
> 
> which could make "a_variable.d" be either signed or unsigned. In the 
> absense of an explicit "signed" or "unsigned" by the programmer, you 
> really won't even _know_ whether "flag" can contain the values {0,1} or 
> {-1,0}.
> 
> Normally you wouldn't ever even care. A one-bit bitfield would only ever 
> really be tested against 0, but it really is possible that when you assign 
> "1" to that value, and read it back, it will read back -1. Try it. 
> 
> Those are the three only types I can think of, but the point is, they 
> really don't have any standard-defined sign. It's up to the compiler. 
> 

And a compiler that makes a_variable.flag unsigned would be brain-dead 
because "int" is always signed.  The signed specifier is only useful for 
forcing chars to carry a sign and it's redundant with any other types.  
Using bitfields requires the knowledge of the sign bit in twos-complement 
just like when you use a signed qualifier for any other definition.  
Having inconsistent behavior on whether it is unsigned or signed based on 
how large the bitfield is (i.e. one bit compared to multiple bits) is 
inappropriate.
