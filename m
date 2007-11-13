Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbXKMKz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbXKMKz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 05:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbXKMKzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 05:55:14 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:3157 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbXKMKzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:55:13 -0500
Date: Tue, 13 Nov 2007 10:55:24 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch.pl and no newline handling
Message-ID: <20071113105524.GE12003@shadowen.org>
References: <8bd0f97a0711121146w30b88cdcs8abf3f5b6bff2d14@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0711121146w30b88cdcs8abf3f5b6bff2d14@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 02:46:30PM -0500, Mike Frysinger wrote:
> the current checkpatch.pl does not reject new files that lack a
> newline, yet rejects patches that fix newlines in files ... quite the
> opposite of what we actually want

apw@pinky$ echo -n "moo" >no-newline.c
apw@pinky$ diff -Nu /dev/null no-newline.c | ./checkpatch.pl -q -no-tree
--no-signoff -
WARNING: adding a line without newline at end of file
#4: FILE: no-newline.c:1:
+moo

total: 0 errors, 1 warnings, 1 lines checked
apw@pinky$ echo "moo" >newline.c
apw@pinky$ diff -Nu no-newline.c newline.c | ./checkpatch.pl -q -no-tree
--no-signoff -
total: 0 errors, 0 warnings, 3 lines checked
apw@pinky$

This should be fixed in the 0.12 release and is fixed in -next.

-apw
