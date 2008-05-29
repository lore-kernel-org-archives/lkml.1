Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbYE2PrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbYE2PrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbYE2PrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:47:03 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:40211 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbYE2PrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:47:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uDCJQRvL3VxvhJ6/h6sM7ItgblclPg9BEpyuMfEXdtufF1slL6zH18k7RpmqOdLIIuuaLxyOYrTi46IfL9OGnmq4pNjh6lprmgC8EtRwQA+a34fx4/SsxzUl8BvUC5/0HD+v4bT+t4jP7rQldmHpTYDlahtXL0BDDj7QfNzU0aw=
Message-ID: <d8d698ae0805290846w7cd2b14j99db2e1e2a9ec7ed@mail.gmail.com>
Date: Thu, 29 May 2008 12:46:56 -0300
From: "Fausto Richetti Blanco" <fausto.blanco@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Pipe buffers' limit of 16 * 4K
Cc: miquels@cistron.nl, riel@redhat.com, jengelh@medozas.de,
       fausto.blanco@gmail.com
In-Reply-To: <alpine.LNX.1.10.0805291633000.19264@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d8d698ae0805231255i4d0da724p68cb2b9376134797@mail.gmail.com>
	 <d8d698ae0805231719g4202edf2k947bba4128385ab6@mail.gmail.com>
	 <20080523205630.444fe2b9@bree.surriel.com>
	 <d8d698ae0805261043u125b653ve73d067cd92caa16@mail.gmail.com>
	 <d8d698ae0805290600s782e16b4pe70d725f55826cf0@mail.gmail.com>
	 <1212067164.8621.3.camel@localhost.localdomain>
	 <alpine.LNX.1.10.0805291633000.19264@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 11:36 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Thursday 2008-05-29 15:19, Miquel van Smoorenburg wrote:
>>On Thu, 2008-05-29 at 10:00 -0300, Fausto Richetti Blanco wrote:
>>
>>Why not use a socketpair() instead of a pipe(). You can adjust the size
>>with setsockopt SO_SNDBUF/SO_RCVBUF (see man socket(7))
>
> Nah, if there's lots of POST requests, and a large buffer for
> each of it, you may end up running into allocation failures.

Well, I think it's an alternative.. A good one, indeed :)

However, I implemented it and run into the limit of /proc/sys/net/core/wmem_max

Do you guys think it's a big impact to change this to a higher value ?
It's meant to only affect the MAX window size, right ? Does it have
any other way of changing this limit (by process or by user, for
exemple) ?

The strange thing here is that setsockopt doesn't fail if I change the
size of the buffer to anything higher than
/proc/sys/net/core/wmem_max. It doesn't work either :)

The implementation with socketpair, adjusting
/proc/sys/net/core/wmem_max, seems good to me. However, I still think
dynamic buffers for pipes a good idea.
