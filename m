Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbYG1PGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbYG1PGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYG1PGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:06:38 -0400
Received: from mx1.melware.net ([78.47.171.162]:60971 "EHLO mx1.melware.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbYG1PGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:06:37 -0400
X-Greylist: delayed 1518 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jul 2008 11:06:37 EDT
Date: Mon, 28 Jul 2008 16:41:18 +0200 (CEST)
From: Armin Schindler <armin@melware.de>
To: roel kluin <roel.kluin@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: isdn/eicon: msg_in_{wrap,read}_pos assigned twice?
In-Reply-To: <488A28F3.6030100@gmail.com>
Message-ID: <alpine.DEB.0.99.0807281640290.16833@k10.melware.de>
References: <488A28F3.6030100@gmail.com>
Organization: Cytronics & Melware
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008, roel kluin wrote:
> vi drivers/isdn/hardware/eicon/message.c +4035
>
> and note two similar tests on line 4035 and 4049:
>
> [else] if (plci->msg_in_read_pos == plci->msg_in_wrap_pos)
>
> after the first test:
>
> 	plci->msg_in_wrap_pos = MSG_IN_QUEUE_SIZE;
> 	plci->msg_in_read_pos = i + MSG_IN_OVERHEAD;
>
> but then after the second test as well:
>
> 	plci->msg_in_read_pos = MSG_IN_QUEUE_SIZE;
> 	plci->msg_in_wrap_pos = MSG_IN_QUEUE_SIZE;
>
>
> So the assignment after the first test has no effect. Is this a bug?

If (plci->msg_in_read_pos == plci->msg_in_wrap_pos) is true in the first 
test it can't be true in the second.
So the code could be optimized a bit. But the first assignments are needed.

If it's false in the first it may become true in the second. So it's not a 
bug. All conditions are really needed.

Armin

