Return-Path: <linux-kernel-owner+w=401wt.eu-S964934AbZGQQg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbZGQQg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 12:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964920AbZGQQg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 12:36:26 -0400
Received: from mx10.kentrox.com ([192.228.33.31]:41498 "EHLO smtp.kentrox.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964899AbZGQQgZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 12:36:25 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] tty: Fix tcdrain hang due to tty chars_in_buffer errors
Date: Fri, 17 Jul 2009 12:36:22 -0400
Message-ID: <2E93DD7A4E576E48956F4A861E8B2CB801137D6D@dubexchange.corp.kentrox.com>
In-Reply-To: <20090717170124.05881456@lxorguk.ukuu.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] tty: Fix tcdrain hang due to tty chars_in_buffer errors
Thread-Index: AcoG97bTaNnJ1VceT+CwdCkPmp7+6QAAXLEA
References: <1247843274-7462-1-git-send-email-jeff_harris@kentrox.com> <20090717170124.05881456@lxorguk.ukuu.org.uk>
From: "Harris, Jeff" <Jeff_Harris@kentrox.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: <alan@linux.intel.com>, <vapier@gentoo.org>, <adobriyan@gmail.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Jul 2009 16:36:24.0981 (UTC) FILETIME=[B9A82450:01CA06FC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That was my other thought, but there are other kernel drivers which do
report errors from chars_in_buffer.  A grep of the code shows
ipw_chars_in_buffer in drivers/char/pcmcia/ipwireless/tty.c,
hvc_chars_in_buffer in hvc_console.c, ntty_chars_in_buffer in nozomi.c,
if_chars_in_buffer in isdn/gigaset/interface.c, etc.  Do they all need
to be updated?  

Should the return type be unsigned int to make the behavior more
explicit?  The signed type may be interpreted along the lines of a read
or write call which returns a count or a negative value to indicate a
failure.

Jeff

-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] 
Sent: Friday, July 17, 2009 12:01 PM
To: Harris, Jeff
Cc: alan@linux.intel.com; vapier@gentoo.org; adobriyan@gmail.com;
linux-kernel@vger.kernel.org; Harris, Jeff
Subject: Re: [PATCH] tty: Fix tcdrain hang due to tty chars_in_buffer
errors

On Fri, 17 Jul 2009 11:07:54 -0400
Jeff Harris <jeff_harris@kentrox.com> wrote:

> If a tty driver's chars_in_buffer callback reports an error, the wait
loop in

chars_in_buffer cannot report an error. It reports how many characters
are in the buffer.

> A process calling tcdrain will block indefinitely if it calls tcdrain
when the
> device is disconnected.

Fix your chars_in_buffer. On a disconnect its quite reasonable to return
0, as they are not buffered any more.

Alan

