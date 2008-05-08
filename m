Return-Path: <linux-kernel-owner+w=401wt.eu-S1761778AbYEHXL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761778AbYEHXL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbYEHXK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:10:57 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39244 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753140AbYEHXKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:10:55 -0400
Date: Fri, 9 May 2008 00:01:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Morten Welinder" <mwelinder@gmail.com>
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Deleting large files
Message-ID: <20080509000124.791abac0@core>
In-Reply-To: <118833cc0805071614j49b10da6hfcbeb08cb3356afb@mail.gmail.com>
References: <118833cc0805071249w36145eb6g7ed5c18d9fdf6fce@mail.gmail.com>
	<Pine.LNX.4.61.0805071820010.25395@chaos.analogic.com>
	<118833cc0805071614j49b10da6hfcbeb08cb3356afb@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> user experience.  Forking a process to do the deletion (a) is pathetic,
> (b) is not currently done, and (c) does not work: you cannot get a result
> right away, i.e., you lose error handling.

I wouldn't call it pathetic. Quite a few big media file tools create a
thread to do deletions of big objects.

The error handling isn't usually a problem. You know any error you can do
anything meaningful with actually occurs immediately or close to it. If
you get errors because of I/O problems in a minutes time there isn't a
sensible response and recovery anyway - nor would a kernel side
asynchronous delete be able to recover any better.

In theory you can push some kind of asynchronous delete threads into the
kernel or extent the AIO interfaces we have to do AIO_delete but at the
end of the day the implementation would effectively be create thread,
unlink, exit - and you can do that neatly and sanely in user space.
