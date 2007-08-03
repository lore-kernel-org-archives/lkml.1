Return-Path: <linux-kernel-owner+w=401wt.eu-S1761397AbXHCDjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761397AbXHCDjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 23:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbXHCDjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 23:39:15 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:61641 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbXHCDjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 23:39:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Z3JA7D757ElQwxwseh46YxH0KupirrmaOjxuzesDwnPKUUI0Thyrmd1kxm5Lm2RBYwNDb4TlKTwKULQAkQUYOvLvGPGG6asyewTiRqRTxRkuFFDD+6HSWBGXJcm3/C/IYCLyD+5qeExdmPjCg5+kl9l8BoQW7tpLNzNQo6gRl+o=
Date: Fri, 3 Aug 2007 11:40:01 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
Message-ID: <20070803034001.GA3476@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange> <Pine.LNX.4.64.0708022157310.9319@fbirervta.pbzchgretzou.qr> <alpine.LFD.0.999.0708030841390.23798@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708030841390.23798@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 08:47:56AM +0530, Satyam Sharma wrote:
>
>
>On Thu, 2 Aug 2007, Jan Engelhardt wrote:
>
>> On Aug 2 2007 21:55, Guennadi Liakhovetski wrote:
>> > [...]
>> >
>> >	struct {
>> >		char c[4];
>> >		int i;
>> >	} t;
>> >	t.i = 0x12345678;
>> >	strcpy(t.c, c);
>> >
>> >and t.i is silently corrupted. Just wanted to ask if this is known, 
>> >really...
>> 
>> What does this have to do with the kernel? The string "0123" is
>> generally _five_ characters long, so c[4] is not enough.
>> Or use strncpy.
>
><nitpicking>
>
>While we're talking of null-termination of strings, then I bet you
>generally want to be using strlcpy(), really. Often strncpy() isn't
>what you want. Of course, if that buffer isn't a string at all, then
>you should be using memfoo() functions and not strbar() ones in the
>first place ...

Afaik, strlcpy() and strlcat() are NOT standard C library functions.
But, I know, they are available in Linux kernel. ;) And yes, they
are better than strn{cpy,cat}().

Regards.

-- 
_   /|
\'o.O'
=(___)=
   U 
