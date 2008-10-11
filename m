Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbYJKMU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbYJKMU7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 08:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYJKMUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 08:20:52 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3721 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbYJKMUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 08:20:51 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Stephen Hemminger" <shemminger@vyatta.com>
Cc: <linux-net@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: recv() hangs until SIGCHLD ?
Date: Sat, 11 Oct 2008 05:20:37 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEFHAFAD.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
In-Reply-To: <48F063C5.3000707@motion-twin.com>
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sat, 11 Oct 2008 05:22:37 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sat, 11 Oct 2008 05:22:37 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nicolas Cannasse wrote:

> The sockets are non-blocking.

Ouch, that's a serious bug. Non-blocking operations shouldn't block!

> Checking with netstat and ss I can confirm that both Send and Recv
> queues are empty, which makes the recv() behavior consistent.
>
> However since this problem does not occur without threads, we can be
> sure that the blame is still on the receiver.
>
> In a practical case, we have a thread blocked in recv() for more than 12
> hours, which is way beyond the timeout of the sender connection. The
> socket has already been closed by the sender so recv() should at least
> be noticed and returns 0.

Can you clarify what you mean by "the socket has already been closed by the
sender"? You mean the other end of the TCP connection shut it down? By "the
socket", you don't mean the socket you called 'recv' on, right? You mean the
socket on the other end that's connected to it?

> Is it safe to assume that when either send() or recv() get interrupted
> by a signal and returns EINTR, no actual data has been either sent or
> consumed ? And if it's not, is there any other way around this ?

EINTR can only be return if 'send' or 'recv' have not sent or received
anything. Otherwise the connection would be left in an indeterminate state.

DS


