Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbYLOQjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbYLOQjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 11:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYLOQjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 11:39:07 -0500
Received: from golem.dinale.com ([82.208.35.193]:44016 "EHLO
	bobrock.dinale.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753548AbYLOQjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 11:39:07 -0500
X-Greylist: delayed 2060 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Dec 2008 11:39:06 EST
Message-ID: <49468024.1020700@dei.unipd.it>
Date: Mon, 15 Dec 2008 17:04:52 +0100
From: Ottavio Campana <ottavio.campana@dei.unipd.it>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Oops when trying to create more than 16000 timers
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm sorry if it is not the best place to ask, but I haven't find any answer.

I am currently developing a software that needs approx 60k timers. I
currently use timer_create and all the relative functions to manage timers.

I've noticed that after having created 16039 timers I always get an oops
from the kernel, which are always of the same kind:

Dec 15 15:20:00 evolution kernel: [601680.417064] BUG: unable to handle
kernel NULL pointer dereference at 0000000000000040 .

I tried looking at kernel/posix-timers.c and I discovered that posix
timers are kept in slab memory. By monitoring the my program I can see
that in /proc/slabinfo the number of timers increases till 16039, when I
get the oops and no more timers are created.

In /prob/slabinfo I have
posix_timers_cache 0 0 192 20 1 : tunables 120 60  8 : slabdata 0 0 0

If I try to increase tunables to 2400 120 16 the maximum number of posix
timers that I can create does not change.

How can I tune the kernel so that it supports 60k or more timers?

Thank for your help,

Ottavio

-- 
Ottavio Campana
Telecommunication Engineer

Lab. Immagini
Dept. of Information Engineering
University of Padova

Via Gradenigo 6/B
35131 Padova
Italy

phone: +39 049 8277641 fax:   +39 049 8277699
e-mail: ottavio.campana@dei.unipd.it
