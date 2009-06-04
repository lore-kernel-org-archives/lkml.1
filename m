Return-Path: <linux-kernel-owner+w=401wt.eu-S1752415AbZFDRRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbZFDRRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 13:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbZFDRQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 13:16:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbZFDRQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 13:16:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, paul@mad-scientist.net,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
In-Reply-To: Oleg Nesterov's message of  Thursday, 4 June 2009 05:15:44 +0200 <20090604031544.GA23930@redhat.com>
References: <20090601161234.GA10486@redhat.com>
	<20090601174159.48acf3f5@lxorguk.ukuu.org.uk>
	<20090601171119.GA13970@redhat.com>
	<20090601184608.6379440c@lxorguk.ukuu.org.uk>
	<20090601182305.GA16372@redhat.com>
	<20090601203845.B010DFC3C7@magilla.sf.frob.com>
	<20090601223241.GA26788@redhat.com>
	<20090601230210.C0B15FC3C7@magilla.sf.frob.com>
	<20090602000850.GA31064@redhat.com>
	<20090603070939.4E31CFC333@magilla.sf.frob.com>
	<20090604031544.GA23930@redhat.com>
X-Windows: a mistake carried out to perfection.
Message-Id: <20090604171458.F0DC7FC3C3@magilla.sf.frob.com>
Date: Thu,  4 Jun 2009 10:14:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fortunately, this doesn't look hard. Whatever we do, we should modify
> dump_write/seek to check fatal_signal_pending() anyway. Because we can't
> know if f_ops->write() pays attention to signals. 

Yes, that sounds fine.

> This means we can just add try_to_freeze().

Right.

> As for exit_mm(), we can use freezer_do_not_count() + freezer_count()
> around the "for (;;)" loop.

Ah yes, sure.


Thanks,
Roland
