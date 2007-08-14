Return-Path: <linux-kernel-owner+w=401wt.eu-S932148AbXHNR3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbXHNR3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 13:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760974AbXHNR2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 13:28:53 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47645 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759604AbXHNR2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 13:28:52 -0400
Date: Tue, 14 Aug 2007 19:28:51 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: O_NONBLOCK is broken
In-Reply-To: <20070814133319.1a8a4871@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0708141925240.10912@fbirervta.pbzchgretzou.qr>
References: <200708141241.44021.vda.linux@googlemail.com>
 <20070814133319.1a8a4871@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 14 2007 13:33, Alan Cox wrote:
>
>> b) Make recv(fd, buf, size, flags) and send(fd, buf, size, flags);
>>    work with non-socket fds too, for flags==0 or flags==MSG_DONTWAIT.
>>    (it's ok to fail with "socket op on non-socket fd" for other values
>>    of flags)
>
>I think that makes a lot of sense, and to be honest other MSG_ flags make
>useful sense and have meaningful semantics that might be helpful
>elsewhere if ever coded that way.
>
>If you want to do this the first job is going to be to sort out the way
>non-block is propogated to device driver read/write handlers. At the
>moment they all check filp->f_flags

And a side effect, kernel code (kthreads) rarely allocate a file
descriptor.


	Jan
-- 
