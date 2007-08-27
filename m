Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbXH0MyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbXH0MyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 08:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbXH0MyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 08:54:07 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:63930 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbXH0MyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 08:54:06 -0400
Date: Mon, 27 Aug 2007 08:43:01 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, Andrew Morton <akpm@osdl.org>,
       David Chinner <dgc@sgi.com>, Michael Rubin <mrubin@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] [RFC][PATCH] clustered writeback
Message-ID: <20070827084301.73217bde@think.oraclecorp.com>
In-Reply-To: <20070827050336.6a7e8e16@laptopd505.fenrus.org>
References: <388214369.05937@ustc.edu.cn>
	<20070827050336.6a7e8e16@laptopd505.fenrus.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007 05:03:36 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> On Mon, 27 Aug 2007 19:21:52 +0800
> > 
> > Because it does the work in small batches of 10 inodes, when the
> > system has <=10 dirty inodes, its behavior will reduce to:
> > - do a full sweep *at once* on every 25s
> > Which means the disk will flicker once every 25s, not bad :)
> 
> 25 seconds is quite not good already though.... it takes a disk a
> second or two of no activity to go into low power mode, every 25
> seconds means you now have at least a 10% constant power cost....
> 
> I don't know the right answer (well other than "make sure inodes
> aren't dirty", which involves fixing apps to not do as much file
> operations, as well as relatime) but just "every 25s is no big deal"
> isn't really the case ;-(

But fixing this isn't the job of this patch....It needs something like
the laptop mode logic where it says ohhhh, the disk is awake, lets send
stuff down.

kupdate hitting on the disk isn't really a new problem, I'd rather
address it with a different patch series.

-chris
