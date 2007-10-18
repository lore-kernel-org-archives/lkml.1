Return-Path: <linux-kernel-owner+w=401wt.eu-S933668AbXJRQFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933668AbXJRQFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 12:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757747AbXJRQFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 12:05:24 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54872 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953AbXJRQFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 12:05:23 -0400
Date: Thu, 18 Oct 2007 18:05:21 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: jaroslav.sykora@gmail.com
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Shadow directories
In-Reply-To: <200710181721.09201.jara@sin.cvut.cz>
Message-ID: <Pine.LNX.4.64.0710181802300.2936@fbirervta.pbzchgretzou.qr>
References: <200710181721.09201.jara@sin.cvut.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 18 2007 17:21, Jaroslav Sykora wrote:
>Hello,
>
>Let's say we have an archive file "hello.zip" with a hello world program source
>code. We want to do this:
>	cat hello.zip^/hello.c
>	gcc hello.zip^/hello.c -o hello
>	etc..
>
>The '^' is an escape character and it tells the computer to treat the file as a directory.

Too bad, since ^ is a valid character in a *file*name. Everything is, with
the exception of '\0' and '/'. At the end of the day, there are no control
characters you could use.

But what you could do is: write a FUSE fs that mirrors the lower content
(lofs/fuseloop/however it was named) and expands .zip files as
directories are readdir'ed or the zip files stat'ed. That saves us
from cluttering up the Linux VFS with such stuff.
