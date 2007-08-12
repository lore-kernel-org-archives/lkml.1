Return-Path: <linux-kernel-owner+w=401wt.eu-S933047AbXHLU4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047AbXHLU4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 16:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933889AbXHLU4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 16:56:18 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:33080 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270AbXHLU4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 16:56:16 -0400
Date: Sun, 12 Aug 2007 22:56:14 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: linux-kernel@vger.kernel.org
Subject: Re: splice question
Message-ID: <20070812205614.GA29485@hardeman.nu>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20070812162820.GA26892@hardeman.nu> <alpine.LFD.0.999.0708121238390.30176@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.999.0708121238390.30176@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 12:41:54PM -0700, Linus Torvalds wrote:
>On Sun, 12 Aug 2007, David H?rdeman wrote:
>> Otherwise I guess I'd have to add a second pipe, then (in a loop)
>> tee() from the first to the second pipe and then splice from the second pipe
>> to a socket. Doesn't sound very elegant and would need quite a lot of extra
>> syscalls.
>
>You really should think of this as a memcpy(), and you'll be in the right 
>mindframe. The system calls themselves are cheap.

Ok, I've implemented it using two pipes, and it works. But it does seem 
a bit wasteful...in case one client is not keeping up, the data will 
have to be tee():ed first from pipe1 to pipe2, only to then find out 
that the splice() from pipe2 to socket only does a partial transfer 
after which the data in pipe2 has to be thrown away and then the loop 
starts over with the next client.

A tee() from pipe1 to the socket could (I imagine) realize immediately 
that the socket does not have enough buffer space and return EWOULDBLOCK 
and avoid at least one copy?

-- 
David Härdeman
