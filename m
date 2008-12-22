Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbYLVSh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbYLVSh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYLVShM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:37:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39255 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbYLVShL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:37:11 -0500
Date: Mon, 22 Dec 2008 13:37:09 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ring_bufer: fix BUF_PAGE_SIZE
In-Reply-To: <20081221085552.GE6395@elte.hu>
Message-ID: <alpine.DEB.1.10.0812221335550.19046@gandalf.stny.rr.com>
References: <4948CADF.6050205@cn.fujitsu.com> <20081218124803.GA31763@elte.hu> <494CBB6D.9070106@cn.fujitsu.com> <20081221085552.GE6395@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 21 Dec 2008, Ingo Molnar wrote:
> * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> > In the old codes, these lines confuse me:
> > return (addr & ~PAGE_MASK) - (PAGE_SIZE - BUF_PAGE_SIZE);
> > addr &= PAGE_MASK;
> > This patch mostly make the codes concordant.
> 
> ah, okay. Steve, any strong feelings against the patch? And we might just 
> go for removing BUF_PAGE_SIZE itself instead.

I'll need to rename BUF_PAGE_SIZE to BUF_SIZE since it is really the size 
of a buffer per page. The pages will now have some header information on 
it to let things like splice take the page away and still be able to 
translate what is on the page.

-- Steve

