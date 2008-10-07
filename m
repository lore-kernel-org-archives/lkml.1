Return-Path: <linux-kernel-owner+w=401wt.eu-S1756434AbYJGAEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbYJGAEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbYJGAEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:04:44 -0400
Received: from daves.isp2dial.com ([69.60.113.26]:33608 "EHLO
	daves.isp2dial.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbYJGAEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:04:44 -0400
From: John Kelly <jak@isp2dial.com>
To: linux-kernel@vger.kernel.org
Subject: Re: User credentials on a unix datagram socket
Date: Tue, 07 Oct 2008 00:04:42 +0000
Message-ID: <200810070004.m9704fZB019302@isp2dial.com>
References: <200810052141.m95LfL2c027165@isp2dial.com>
In-Reply-To: <200810052141.m95LfL2c027165@isp2dial.com>
X-Mailer: Forte Agent 1.93/32.576 English (American)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Hard2Crack: 0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Oct 2008 21:41:22 +0000, John Kelly <jak@isp2dial.com>
wrote:

>The socket(7) man page seems to imply that user credentials cannot be
>sent on a unix datagram socket, unless socketpair() created it.

>> SO_PEERCRED
>>   Return the credentials of the foreign process connected to this socket.
>>   This is only possible for connected AF_UNIX stream sockets and AF_UNIX
>>   stream and datagram socket pairs created using socketpair(2);

>But through trial and error, without reading any kernel source, I
>learned that you can send user credentials on a regular unix datagram
>socket which was not created with socketpair().

>I'm unsure what SO_PEERCRED is intended for; I used SO_PASSCRED in my
>server code, and it works.

Maybe I'm the only one on the planet interested in this subject, but
for posterity ... after browsing net/unix/af_unix.c, I see ...

Using SO_PEERCRED with getsockopt(2) reads an sk_peercred struct.  It
seems this data is available in the kernel, without the client sending
credentials as ancillary data.  In af_unix.c, unix_stream_connect and
unix_socketpair set this structure, but unix_dgram_connect does not.

So apparently, the socket(7) man page is accurate.  However, it could
mislead one towards a wrong conclusion ...

As I learned by trial and error, you CAN get user credentials on a
regular datagram socket by using SO_PASSCRED, you just have to do it
the hard way, with the client explicitly sending his credentials as
ancillary data.

Works for me ....


-- 
Webmail for Dialup Users
http://www.isp2dial.com/freeaccounts.html
 
