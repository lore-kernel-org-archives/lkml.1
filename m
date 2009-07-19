Return-Path: <linux-kernel-owner+w=401wt.eu-S1751963AbZGSXHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbZGSXHS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 19:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZGSXHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 19:07:16 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:38256 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbZGSXHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 19:07:15 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: possible regression with pty.c commit
References: <20090711191556.GA3845@localdomain.by>
	<20090711232452.4dc7c1ba@lxorguk.ukuu.org.uk>
	<20090711235530.GA3231@localdomain.by>
	<20090713124834.5c3ecc5d@lxorguk.ukuu.org.uk>
X-Yow: After THIS, let's go to PHILADELPHIA and have TRIPLETS!!
Date: Mon, 20 Jul 2009 01:07:09 +0200
In-Reply-To: <20090713124834.5c3ecc5d@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Mon, 13 Jul 2009 12:48:34 +0100")
Message-ID: <m2prbw6zmq.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.96 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a testcase with expect:

#!/usr/bin/expect -f
spawn echo foo bar
expect {
    "foo bar" {puts $expect_out(buffer)}
}

With d945cb9cce20ac7143c2de8d88b187f62db99bdc reverted, I get the
expected output:

$ expect -f pty.exp
spawn echo foo bar
foo bar
foo bar

Without the revert the expect process receives EIO when it tries to read
the output of the echo process which already died.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
