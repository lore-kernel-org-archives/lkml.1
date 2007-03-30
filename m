Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbXC3XYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbXC3XYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 19:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933099AbXC3XYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 19:24:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:6090 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932950AbXC3XYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 19:24:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=jEV1Nv+9xjjxzCQ3huYlM/Wi7XyGSNRxo1WPmuIocSxLZjC+rztJAilfeioNL5kjtmZNMZnfpJvPtbXErN90x/BlzfYguUYbuvvMdNB2sGP72b30dzj9oJO7AsMN02PXlvek6Yr7hwi8SIWSZNpqGFLkuXULdXYe6BayzOsUxko=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
Date: Sat, 31 Mar 2007 01:24:22 +0200
User-Agent: KMail/1.8.2
Cc: "Michael K. Edwards" <medwards.linux@gmail.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       "David M. Lloyd" <dmlloyd@flurg.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0703071712210.3672@alien.or.mcafeemobile.com> <f2b55d220703080840xb0a1da0w41051a7c4a7ac4e3@mail.gmail.com> <Pine.LNX.4.64.0703080919541.10832@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703080919541.10832@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703310124.22082.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 March 2007 18:28, Linus Torvalds wrote:
> The sad part is that there really is no reason why the BSD crowd couldn't 
> have done recvmsg() as an "extended read with per-system call flags", 
> which would have made things like O_NONBLOCK etc unnecessary, because you 
> could do it just with MSG_DONTWAIT..

Wait a second here... O_NONBLOCK is not just unnecessary - it's buggy!

Try to do nonblocking read from stdin (fd #0) -
* setting O_NONBLOCK with fcntl will set it for all other processes
  which has the same stdin!
* trying to reset O_NONBLOCK after the read doesn't help (think kill -9)
* duping fd #0 doesn't help because O_NONBLOCK is not per-fd,
  it's shared just like filepos.

I really like that trick with recvmsg + MSG_DONTWAIT instead.
--
vda
