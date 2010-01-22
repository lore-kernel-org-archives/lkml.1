Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693Ab0AVL2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab0AVL2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 06:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642Ab0AVL2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 06:28:13 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39029 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753788Ab0AVL2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 06:28:10 -0500
Date: Fri, 22 Jan 2010 11:30:21 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stepan Chatalyan <kehcho@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hi all, bug or design flaw?
Message-ID: <20100122113021.2c850509@lxorguk.ukuu.org.uk>
In-Reply-To: <22d9728d1001211705i4cf90df2ha730061ea01972b6@mail.gmail.com>
References: <22d9728d1001211705i4cf90df2ha730061ea01972b6@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (3) I tried to execut it with "./createdfile"
> [kehcho@kehcho] [/tmp]$ ./createdfile
> -bash: ./createdfile: /bin/bash: bad interpreter: Permission denied

The kernel noexec blocks execution of binaries from the file system. It's
not really a 'security' model so much as a useful historic way of
stopping people running wrong things by accident, and over NFS and the
like of stopping people trying to run binaries for the wrong machine

> (4) I tried to execute it, but pass to bash ". /tmp/createdfile"
> 
> [kehcho@tornadowt] [/tmp]$ . /tmp/createdfile
> Probe...
> 
> It is a kernel bug or I just report a another one?

Then bash loads the file and interprets the commands - not the kernel.

Data is data - there is no real distinction between "instructions" to
execute and "data files" in computing.

The "nosuid" bit is different. Only the kernel has the power to grant
suid status so while you could run a noexec program by hand loading it
you couldn't make it run setuid that way.
