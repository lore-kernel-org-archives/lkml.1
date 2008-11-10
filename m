Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbYKJX7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbYKJX7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 18:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbYKJX6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 18:58:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340AbYKJX6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 18:58:53 -0500
Date: Mon, 10 Nov 2008 15:58:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial/8250: fix uninitialized warnings
Message-Id: <20081110155808.a4d94ee7.akpm@linux-foundation.org>
In-Reply-To: <20081110234843.0fba9f16@lxorguk.ukuu.org.uk>
References: <20081105022353.7CB0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081104174142.360a964a@lxorguk.ukuu.org.uk>
	<20081110143039.6f21fdc3.akpm@linux-foundation.org>
	<20081110234843.0fba9f16@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008 23:48:43 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > That's a regression in current gcc, surely?
> 
> Oh and as a PS: Gcc is I believe right because if the loop is run zero
> times then pos = NULL (ie n == NULL so the first BUG_ON fires)

Whoa.  That would be clever of it.


On about half the architectures, BUG is not considered to be no-return.
Dunno if that's a gcc shortcoming or if the architectures just haven't
implemented it properly yet.  This causes those architectures to
generate quite a few warnings in generic code which don't appear on
x86 (this would be one such case if your above theory is correct).

This is fairly irritating of those architectures, as I keep on going
in asking "what's up" and deciding "oh, that again".
