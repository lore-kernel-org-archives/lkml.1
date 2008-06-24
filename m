Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbYFXFlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbYFXFlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbYFXFl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:41:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44036 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbYFXFl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:41:28 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5323"; a="4171440"
Message-ID: <48608909.5060703@qualcomm.com>
Date: Mon, 23 Jun 2008 22:41:29 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Jarek Poplawski <jarkao2@o2.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueues: insert_work: use "list_head *" instead of
 "int tail"
References: <20080612165120.GA12177@tv-sign.ru>	 <20080612165550.GA12183@tv-sign.ru> <1213290074.31518.136.camel@twins>	 <20080612174433.GA12204@tv-sign.ru> <1213295939.31518.159.camel@twins>	 <20080613142658.GA9147@tv-sign.ru> <1213368184.16944.20.camel@twins>	 <20080613151725.GA9194@tv-sign.ru> <1213371132.16944.49.camel@twins>
In-Reply-To: <1213371132.16944.49.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the silence. I stirred the discussion but got buried in other stuff.

Peter Zijlstra wrote:
> Anyway, I think before we go further down this road, we'd better see if
> anybody actually needs this. Not that theorizing about this problem
> isn't fun,... but... :-)

Let me see if I can sum up current state of affairs. Looks like people are in
general ok with Oleg's patches. Fancier stuff is much more complex and may not
be needed.
Combining Oleg's patches with auditing current flush_scheduled_work() users
and fixing them to use cancel_work_sync() (and in some cases flush_work())
gives us desired behaviour. Which is:
	1. minimizing flush overhead
	2. handling work queue thread starvation

Does that sound right ? Or did I miss something in the discussion ?

If that sounds right we should resend the patches to Andrew with formal ACKs
because I do not seem them in mainline, linux-next or -mm.

Thanks
Max
