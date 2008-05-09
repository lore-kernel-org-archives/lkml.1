Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbYEIEh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbYEIEh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 00:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755218AbYEIEhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 00:37:13 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45969 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbYEIEhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 00:37:11 -0400
Message-ID: <4823D4EC.7060407@garzik.org>
Date: Fri, 09 May 2008 00:37:00 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       marc.c.dionne@gmail.com, dl9pf@gmx.de, bug-track@fisher-privat.net,
       sitsofe@yahoo.com
Subject: Re: [PATCH] Re: [git patches] libata updates - (improve post-reset
 device ready test) regression
References: <20080506154847.GA15299@havoc.gtf.org> <20080507145616.GA2210@gentoox2.trippelsdorf.de> <48231DAF.7070900@garzik.org> <4823BD8E.40109@gmail.com>
In-Reply-To: <4823BD8E.40109@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> This means that we need to make custom readiness tests for controllers 
> using 0x77 or 0x7f.  Eeeek... Both groups of controllers are behaving in 
> incorrect way.  Controllers shouldn't use 0x77 or 0x7f for either busy 
> or ready states - it's invalid for both, yet, some use the 77/7f for 
> busy while others use them for ready state.  Great.  :-(


I think that's assuming too much?  PATA and SATA are quite different 
here... in PATA the status is mostly the value from the device directly 
off the wires.  in SATA, it may be from the device or from the 
controller.  And "smart" or firmware-based controllers may generate 
their own status, too, apart from the device's status.

So that results in varied status returns, and not all the time is a 
definite "ready" or "not ready" obvious.

	Jeff


