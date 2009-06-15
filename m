Return-Path: <linux-kernel-owner+w=401wt.eu-S1760474AbZFOXvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760474AbZFOXvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 19:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZFOXvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 19:51:43 -0400
Received: from sous-sol.org ([216.99.217.87]:48118 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbZFOXvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 19:51:43 -0400
Date: Mon, 15 Jun 2009 16:51:45 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: x86_64/kdump crashkernel reservation breakage in 2.6.31-rc
Message-ID: <20090615235145.GD30071@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hesitate to label this a regression since 2.6.30, but at least user
visible change since 2.6.30 that at a minimum needs some docs updates.

The commit "ceefccc: x86: default CONFIG_PHYSICAL_START and
CONFIG_PHYSICAL_ALIGN to 16 MB" has a side effect for kdump users.
The problem is a little convoluted because the typical setup for kdump
includes:

crashkernel=64M@16M or crashkernel=128M@16M

These uses don't account for a relocatable kernel which could omit the
@X location specifier, but it's the typical documented method[1][2][3].

Trouble is, now the original kernel loads at 16MB since it's alignment
request will push it up from the old default of 2MB, and the existing
attempt to reserve a region for the crashkernel will fail.

I think the docs are the problem here, in that they don't adequately
prepare a user for the (now common) relocatable kernel case.
Alternatively, back out the CONFIG_PHYSICAL_ALIGN change...

Thoughts?

thanks,
-chris

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/kdump/kdump.txt;hb=HEAD#l271
[2] http://fedoraproject.org/wiki/Kernel/kdump
[3] http://kbase.redhat.com/faq/docs/DOC-6039
