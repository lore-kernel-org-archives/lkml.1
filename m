Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbXH0MES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbXH0MES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 08:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbXH0MEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 08:04:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43203 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbXH0MEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 08:04:09 -0400
Date: Mon, 27 Aug 2007 05:03:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Chris Mason <chris.mason@oracle.com>, Andrew Morton <akpm@osdl.org>,
       David Chinner <dgc@sgi.com>, Michael Rubin <mrubin@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] [RFC][PATCH] clustered writeback
Message-ID: <20070827050336.6a7e8e16@laptopd505.fenrus.org>
In-Reply-To: <388214369.05937@ustc.edu.cn>
References: <388214369.05937@ustc.edu.cn>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007 19:21:52 +0800
> 
> Because it does the work in small batches of 10 inodes, when the
> system has <=10 dirty inodes, its behavior will reduce to:
> - do a full sweep *at once* on every 25s
> Which means the disk will flicker once every 25s, not bad :)

25 seconds is quite not good already though.... it takes a disk a
second or two of no activity to go into low power mode, every 25
seconds means you now have at least a 10% constant power cost....

I don't know the right answer (well other than "make sure inodes aren't
dirty", which involves fixing apps to not do as much file operations,
as well as relatime) but just "every 25s is no big deal" isn't really
the case ;-(
