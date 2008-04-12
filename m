Return-Path: <linux-kernel-owner+w=401wt.eu-S1760982AbYDLJI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760982AbYDLJI3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 05:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758887AbYDLJIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 05:08:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38831 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758880AbYDLJIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 05:08:18 -0400
Message-ID: <48007C00.7070100@garzik.org>
Date: Sat, 12 Apr 2008 05:08:16 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb1000.c: stop inlining largish static functions
References: <200803310102.43277.vda.linux@googlemail.com>
In-Reply-To: <200803310102.43277.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> Hi Jeff,
> 
> Can you take this patch into your net driver fixes tree?
> 
> drivers/net/sb1000.c has lots of inlined static functions.
> 
> Mst of them are used at initialization, wait for some
> hardware register to change (wait using yield, sleep etc),
> or do slow port-based I/O. Inlining thse "for speed" makes no sense.
> 
> This patch removes "inline" from biggest static function
> (regardless of number of callsites - gcc nowadays auto-inlines
> statics with one callsite).
> 
> Size difference for 32bit x86:
> 
>    text    data     bss     dec     hex filename
>    6299     129       0    6428    191c linux-2.6-ALLYES/drivers/net/sb1000.o
>    5418     129       0    5547    15ab linux-2.6.inline-ALLYES/drivers/net/sb1000.o
> 
> (I also see some other optimization opportunities,
> will test and send a patch separately).
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

applied both patches


