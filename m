Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbXDMMYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbXDMMYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 08:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbXDMMYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 08:24:49 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:57161 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753960AbXDMMYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 08:24:48 -0400
Message-ID: <461F74F0.1070206@aitel.hist.no>
Date: Fri, 13 Apr 2007 14:17:52 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [CRYPTO] is it really optimized ?
References: <38b2ab8a0704121239sd848440t6ed23d71dc68798c@mail.gmail.com>
In-Reply-To: <38b2ab8a0704121239sd848440t6ed23d71dc68798c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau wrote:
> Hi,
>
> After reading the crypto code and trying to implement a AES driver,
> I'm wondering if the current  implementation is optimum. My plan is to
> use _exclusively_ the AES driver to encrypt filesystems by using
> eCryptfs for example.
>
> But it seems that because the current implementation of the crypto
> core allows the drivers to be accessed by any part of the kernel at
> any time, that forces the AES driver to do extra works for each block
> ciphering: mainly they are (a) set the key in AES controller (b)
> generate the decryption key if in decrypt mode.
>
> So is this interpretation right ? If so wouldn't it be appropriate to
> introduce a mechanism to reserve this AES hardware for a special
> purpose (filesystem encryptions) and thus make it as fast as possible
> ?
>
Would this really help?
When reading/writing files, most of the time is i/o-wait, isn't it?

Reserving the device exclusively seems excessive. How about
a quick test to see if someone else have been using it since
the last time your crypto-fs used it?  If nobody else used it, then
you don't need to reset they key and so on.

If nobody else is using the AES controller, you get the same speed
as with a reservation.  If something else is using AES then it won't be
as fast, but then the AES controller have been used for other useful
work as well.  Other parts of the kernel surely won't use it just for 
fun. :-)

Helge Hafting


