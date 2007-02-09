Return-Path: <linux-kernel-owner+w=401wt.eu-S1945947AbXBIA76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945947AbXBIA76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945973AbXBIA76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 19:59:58 -0500
Received: from smtp-out.google.com ([216.239.45.13]:24955 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945947AbXBIA75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 19:59:57 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=HHMGpzrnmGVdpKaazGrUb3XKN9mY8fG8zPFNmWNOIFpc+5mbn+WqY/wyDxDmw4Pmz
	jUZll/EyH1fiRGB6wxI8A==
Date: Thu, 8 Feb 2007 16:59:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <Pine.LNX.4.64.0702081632200.8424@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702081643280.30166@chino.kir.corp.google.com>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702082202180.24888@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081324090.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081432320.27603@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702081528070.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081554380.29559@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702081632200.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007, Linus Torvalds wrote:

> No it's not.
> 
> You just don't understand the C language. 
> 
> And if you don't understand the C language, you can't say "that's what the 
> int says". It says no such thing.
> 
> The C language clearly says that bitfields have implementation-defined 
> types. So when you see
> 
> 	struct dummy {
> 		int flag:1;
> 	} a_variable;
> 
> if you don't read that as "oh, the sign of 'flag' is implementation- 
> defined", then you simply aren't reading it right.
> 

Maybe you should read my first post, we're talking about gcc's behavior 
here, not the C standard.  My criticism was that any compiler that makes 
a_variable.flag unsigned is brain-dead and I was arguing in favor of gcc 
treating plain int bitfields as signed ints (6.7.2, 6.7.2.1).  This has 
_nothing_ to do with the fact that the standard leaves it implementation 
defined.

Naturally you should define it's signness explicitly in your code since it 
is implementation defined.  That's not the point.

Just because a compiler CAN consider a_variable.flag as unsigned doesn't 
mean it makes sense.  It makes no sense, and thus is brain-dead.
