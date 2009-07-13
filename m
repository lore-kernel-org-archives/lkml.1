Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbZGMLrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbZGMLrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 07:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbZGMLrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 07:47:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45160 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755426AbZGMLrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 07:47:45 -0400
Date: Mon, 13 Jul 2009 12:48:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: possible regression with pty.c commit
Message-ID: <20090713124834.5c3ecc5d@lxorguk.ukuu.org.uk>
In-Reply-To: <20090711235530.GA3231@localdomain.by>
References: <20090711191556.GA3845@localdomain.by>
	<20090711232452.4dc7c1ba@lxorguk.ukuu.org.uk>
	<20090711235530.GA3231@localdomain.by>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Alan, I forgot to tell - I'm using KDE 3.5.9 (3.5.10). Don't know whether this can be reproduced with KDE 4.x.x.

Dumping out the traces tty side the tty code appears to be
working correctly. The userspace on the other hand appears broken and to
only work by chance with the old code.

For one it wants for new output to appear before checking for "Password:"
and in doing so consumes any partial output it receives without checking.
I suspect it should be doing line += more

One for the KDE people as its not the kind of thing we can fudge back
kernel side if my diagnosis is right.
