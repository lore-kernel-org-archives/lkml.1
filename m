Return-Path: <linux-kernel-owner+w=401wt.eu-S1751053AbXBZCQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053AbXBZCQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 21:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbXBZCQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 21:16:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:46980 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751052AbXBZCQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 21:16:46 -0500
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 26 Feb 2007 02:54:39 +0100
From: kalium@gmx.de
Message-ID: <20070226015439.97500@gmx.net>
MIME-Version: 1.0
Subject: latencies due to disk writes
To: linux-kernel@vger.kernel.org
X-Authenticated: #361948
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/Kg+o2P2fKa9a9+rwQx5F81M5tlq7fKARO9jkk6V
 J7m2oHG0OjvxxY2jNwSrO91wc= 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I'm experiencing extreme lags during disk writes. I have read somewhere (didn't save the URI, sigh) that this is actually related to bad (non-existing) write io priorities (CFQ only manages file reads).

I could imagine two quick, easy and probably quite effective ways to prevent such lags:

1.) don't flush buffers to disk at once more than necessary.

2.) relate CPU niceness to max write buffer fill level (ie. the point where it gets forced to be flushed to disk -- a conservative estimate would be much better than nothing): (100-5*nicelevel)%, ie. writes for processes having nice level 19 are blocked/delayed until the write buffer is below 5%. That way, the accounting is done at a higher and probably easier to access level.

Maybe I'm just talking nonsense, but nonetheless, here are my 2 cents.

Best regards,
Mark

p.s. please CC me as I'm not subscribed to this list.
-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: www.gmx.net/de/go/mailfooter/topmail-out
