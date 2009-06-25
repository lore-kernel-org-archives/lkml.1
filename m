Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbZFYIJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbZFYIJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 04:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbZFYIJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 04:09:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56144 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751622AbZFYIJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 04:09:21 -0400
Date: Thu, 25 Jun 2009 09:10:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] allow execve'ing "/proc/self/exe" even if /proc is not
  mounted
Message-ID: <20090625091002.0b8203a7@lxorguk.ukuu.org.uk>
In-Reply-To: <1158166a0906241600w5f7f4ffcm49d9c849f0c27f72@mail.gmail.com>
References: <1158166a0906241600w5f7f4ffcm49d9c849f0c27f72@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> With this patch, it is possible to execute /proc/self/exe
> even if /proc is not mounted. In the below example,
> ./sh is a static shell binary:

What if the user has procfs mounted somewherelse, what if they are in a
chroot where you don't want them to patch the binary and re-exec it ?

It would be far far cleaner for NOMMU to have a NOMMU private "reexec()"
call that didn't rely on procfs or hacking names into the kernel.

So NAK

Alan
