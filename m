Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbZLNAup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbZLNAup (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbZLNAuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:50:44 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44921 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754931AbZLNAun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 19:50:43 -0500
Date: Mon, 14 Dec 2009 00:50:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefani Seibold <stefani@seibold.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] kfifo: fix warn_unused_result
Message-ID: <20091214005059.6b125fef@lxorguk.ukuu.org.uk>
In-Reply-To: <20091213142907.d0ac63da.akpm@linux-foundation.org>
References: <1260523108.27010.7.camel@wall-e>
	<20091213142907.d0ac63da.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The rest of the patch seems to be adding BUG()s if kfifo_in() fails. 
> All over the place.
> 
> If that's the appropriate way to handle failure for these callsites
> then it would be neater to do this in the callee.  ie, add a new

BUG_ON is a bit extreme for most of those if they fail. WARN_ONCE perhaps
given the usual consequences are minor (eg pointer jumping)

