Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbYJFS3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbYJFS3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 14:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYJFS3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 14:29:25 -0400
Received: from sunrise.pg.gda.pl ([153.19.40.230]:61572 "EHLO
	sunrise.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbYJFS3Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 14:29:25 -0400
Date: Mon, 6 Oct 2008 20:28:34 +0200
From: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH 0/0] SIGWINCH problem with terminal apps
Message-ID: <20081006202834.5b6c5092@merlin.oi.pg.gda.pl>
In-Reply-To: <20081006141306.6a1f0a15@lxorguk.ukuu.org.uk>
References: <20081006140708.7911f101@merlin.oi.pg.gda.pl>
	<20081006141306.6a1f0a15@lxorguk.ukuu.org.uk>
Organization: =?UTF-8?B?R2RhxYRzaw==?= University of Technology
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Mon, 6 Oct 2008 14:13:06 +0100 - Alan Cox <alan@lxorguk.ukuu.org.uk>:
> > So as a quick solution I made patches which move mentioned updates
> > before kill_pgrp() calls. As I tested modified kernel there is no
> > observed effect now. So I send patchs.
> 
> NAK - this might happen to make the race miss on your box but it's
> not a fix of any kind.

It depends. If mutexes are not working properly only in case of signal
sending then moving variables modification before kill_pgrp() call
could be a quite good enough solution too. Mutexes seems to be faster
and more efficient then semaphores for example.
 
> The code was never race free, the scheduler change made the problem
> show up more. Later 2.6.27-rc has patches that use the termios lock
> across TIOCG/SWINSZ and deal with the problem properly.

Maybe but what with older versions. Anyway the problem is if mutexes
are usable here or not.
 
Regards

-- 
Adam Tlałka
