Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbZF2W0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbZF2W0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 18:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZF2W0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 18:26:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47647 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751192AbZF2W0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 18:26:13 -0400
Date: Mon, 29 Jun 2009 23:27:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] make execve(NULL) re-execute current binary
Message-ID: <20090629232733.7ae52b7f@lxorguk.ukuu.org.uk>
In-Reply-To: <200906300003.39440.vda.linux@googlemail.com>
References: <200906300003.39440.vda.linux@googlemail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 00:03:39 +0200
Denys Vlasenko <vda.linux@googlemail.com> wrote:

> Hi Al, Andrew, folks,
> 
> This is a version 2 of re-execution patch.
> 
> I replaced hardcoded "/proc/self/exe" with execve(NULL)

So you add hacks to sys_execve, which means hacks on every system that
doesn't need it and also undefined behaviour if you use the feature when
it isn't present.

This makes no sense.

> extension in the hopes that this is considered less ugly.
> Also I tried to format code according to Andrew's wishes.
> 
> Handling execve(NULL) requires adding a bit of code
> to per-architecture sys_execve().

Please implement sys_reexec() as was suggested before. Not only does it
allow this stuff to stay out of the exec() call without risking mashing
up the API and changing ABI in odd corner cases it means its actually
going to be usable by apps - because a reexec() is going to give you a
-ENOSYS on older platforms not randomness.

> In the attached patch, it is done only on x86.
> If this patch will be ACKed in principle,
> the final version will do it for all architectures.

NAK in principle.

Alan
