Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbZFEWOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbZFEWOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 18:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZFEWNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 18:13:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751468AbZFEWNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 18:13:54 -0400
Date: Fri, 5 Jun 2009 15:13:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: lkml@morethan.org, linux-kernel@vger.kernel.org
Subject: Re: [Compile Warning] 2.6.30-rc8 build
Message-Id: <20090605151346.8fcdd62e.akpm@linux-foundation.org>
In-Reply-To: <20090605230641.2b3013c4@lxorguk.ukuu.org.uk>
References: <200906051143.06119.lkml@morethan.org>
	<20090605190138.5ac32f94@lxorguk.ukuu.org.uk>
	<20090605145756.ed566f48.akpm@linux-foundation.org>
	<20090605230641.2b3013c4@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009 23:06:41 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > I don't think there's any way in which gcc can deduce that h->first is
> > non-zero on entry to that loop.  Even if it inlines
> > serial_unlink_irq_chain() into serial8250_shutdown().
> 
> Why does it care ?
> 
> Suppose the list is empty, n is loaded with NULL
> 
> That follows the BUG_ON path which expands to include a function marked
> as not returning

Ah, OK.

btw, I think there are still several architectures whose BUG() isn't
correctly set up to tell gcc that it doesn't return.  Not that this is
a reason to change the serial code.
