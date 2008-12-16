Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbYLPOLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbYLPOLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 09:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585AbYLPOKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 09:10:50 -0500
Received: from co203.xi-lite.net ([149.6.83.203]:46725 "EHLO co203.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432AbYLPOKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 09:10:49 -0500
X-Greylist: delayed 1663 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Dec 2008 09:10:48 EST
Message-ID: <4947B065.5080405@parrot.com>
Date: Tue, 16 Dec 2008 14:43:01 +0100
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
CC: linux-serial@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
       linux-kernel@vger.kernel.org
Subject: Re: s3c24xx : TIOCM_CTS handling problem
References: <48D242DC.30102@parrot.com>
In-Reply-To: <48D242DC.30102@parrot.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 Dec 2008 13:43:59.0314 (UTC) FILETIME=[592BE320:01C95F84]
X-AV-Checked: No Virus Found
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthieu CASTET a écrit :
> Hi,
> 
> there is a problem in samsung soc serial driver with the report of
> TIOCM_CTS in get_mctrl.
> 
> The uart layer check the status of the TIOCM_CTS in the open or
> set_termios function and cache the result in the tty->hw_stopped flag.
> 
> Then when sending data, in the function uart_start, it check
> tty->hw_stopped flag before calling the start_tx uart driver callback.
> 
> 
> For the samsung uart driver it means :
> - if the other side is not connected or in a reset state, then CTS
> signal is not activated
> - we open and configure the uart. get_mctrl don't report TIOCM_CTS flag.
> uart layer set tty->hw_stopped flag.
> - we connect or start the other side. CTS signal become activated.
> - we send some characters on the uart. This call uart_write which fill
> uart tx queue and call uart_start. uart_start doesn't call driver
> start_tx because tty->hw_stopped flag is set.
> - because driver start_tx is never call, the data is never send on the uart.
> 
>>From what I see, working driver managing TIOCM_CTS flag (amba-pl011,
> 8250), call uart_handle_cts_change when the uart driver detect a CTS
> signal change (via a interrupt).
> 
> Because the samsung controller doesn't generate an interrupt when CTS
> signal change, we can't call uart_handle_cts_change.
> 
> And easy fix could be to always report TIOCM_CTS.
> 
Ping ?

The bug is still present on git tree and I have got no replies.


Matthieu
