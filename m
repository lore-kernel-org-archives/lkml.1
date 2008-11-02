Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYKBTpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYKBTpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 14:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYKBTpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 14:45:06 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:18557 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbYKBTpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 14:45:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qSfHTbFy002dy/OYlQO/tSllmdGBc3d/sZyXK+uD5y3qu80yzAF/jloWhWP2Jokqvr
         Sam5hlbuxti2wUgZFKV9MOqO6AvHh15jycgP6OENd7bkt6AGch/zuBrsOPxwIEZ2+vOB
         +ZMKyoWhCr5ZLY+MhbI8BEojgeFq9to5YFjTM=
Message-ID: <b2cc26e40811021115h1bf711c7i2b220a92f7cf1abc@mail.gmail.com>
Date: Sun, 2 Nov 2008 20:15:57 +0100
From: "Olaf van der Spek" <olafvdspek@gmail.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: epoll behaviour after running out of descriptors
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <490DFB2D.3090906@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b2cc26e40811010938k3864c48j45ce55af09516302@mail.gmail.com>
	 <Pine.LNX.4.64.0811021022120.9451@alien.or.mcafeemobile.com>
	 <b2cc26e40811021033r115225e2x4747a17fc2b30256@mail.gmail.com>
	 <Pine.LNX.4.64.0811021047300.9451@alien.or.mcafeemobile.com>
	 <b2cc26e40811021051kc748db3x44231dc0c085a8d6@mail.gmail.com>
	 <490DFB2D.3090906@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 2, 2008 at 8:10 PM, Eric Dumazet <dada1@cosmosbay.com> wrote:
> On listen queue, socket is still ready for an accept().

True, but not handy.

> Since you use edge trigered epoll, you'll only reveive new notification.

The strace shows I receive 10+.
If a return with EMFILE is indeed a no-op, I should receive only one.

> You probably had in you app a : listen(sock, 10), so after 10 notifications,
> your listen queue is full and TCP stack refuses to handle new connections.

I've got listen(l, SOMAXCONN);
IIRC SOMAXCONN is 128.

>  close(newfd); /* forget this incoming connection, we dont have enough fd */

Why not keep them in the queue until you do have enough descriptors?

> Of course, if your application is multi-threaded, you might adapt (and
> eventually reserve
> one emergency fd per thread)

Sounds like a great recipe for race conditions. ;)
