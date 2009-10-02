Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbZJBLtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbZJBLtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 07:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZJBLtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 07:49:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37177 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753413AbZJBLtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 07:49:24 -0400
Date: Fri, 2 Oct 2009 12:49:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: lenrek@me.com
Cc: linux-kernel@vger.kernel.org, lenrek@me.com
Subject: Re: [PATCH] drivers/char/pcmcia/synclink_cs.c: BKL pushdown?
Message-ID: <20091002124945.1814a2c3@lxorguk.ukuu.org.uk>
In-Reply-To: <060E5EC8-93F4-4AF1-889F-04A13378CB8D@me.com>
References: <060E5EC8-93F4-4AF1-889F-04A13378CB8D@me.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Oct 2009 19:37:21 +0900
lenrek@me.com wrote:

> I found the counterpart of function mgslpc_wait_until_sent
> in drivers/char/synclinkmp.c (wait_until_sent) is modified to
> issue (un)lock_kernel.  This patch does the same modification.
> 
> However, I'm afraid similar modifications are necessary further on  
> functions
> mgslpc_ioctl and mgslpc_write_room.

The push down work normally eliminated BKL calls that were demonstrably
not needed and left it in anywhere that needed thought. Do those
functions still really need the BKL ?
