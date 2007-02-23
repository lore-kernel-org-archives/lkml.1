Return-Path: <linux-kernel-owner+w=401wt.eu-S1752173AbXBWIYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbXBWIYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 03:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbXBWIYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 03:24:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39378 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbXBWIYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 03:24:32 -0500
Subject: Re: cat reading problem
From: Arjan van de Ven <arjan@infradead.org>
To: Mockern@yandex.ru
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45DEA098.000003.11666@webmail12.yandex.ru>
References: <45DEA098.000003.11666@webmail12.yandex.ru>
Content-Type: text/plain; charset=UTF-8
Organization: Intel International BV
Date: Fri, 23 Feb 2007 09:24:30 +0100
Message-Id: <1172219070.3265.43.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> result of strace cat is identical, but in tty case I can't see nothing. Why does cat write nothing at my console?
> 
> Thank you, 
> 
> ------------------------------------------------------------------------------------
> 
> root@test:/home# strace cat  < hello
> │c│c│c│c│c│c│c│c│c│c│c│c..
> munmap(0x40017000, 5664)                = 0
> getuid32()                              = 0
> getgid32()                              = 0
> setgid32(0)                             = 0
> setuid32(0)                             = 0
> read(0, "Hello World!", 8192)           = 12
> write(1, "Hello World!", 12Hello World!)            = 12

you read "Hello World!" and you write "Hello World!" to the console

> read(0, "\376\377\377f\377\330\0000", 8192) = 8
> write(1, "\376\377\377f\377\330\0000", 8│║ f0) = 8

and here you read garbage from the input, so you write garbage out,
which probably confuses the heck out of your terminal for not being
correct UTF-8


