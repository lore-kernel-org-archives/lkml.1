Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbZC3XLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbZC3XLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 19:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbZC3XLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 19:11:07 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55099 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbZC3XLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 19:11:06 -0400
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc 1/6: implement support for automounts in task directories
References: <20090330225326.GB19892@x200.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 30 Mar 2009 16:10:59 -0700
In-Reply-To: <20090330225326.GB19892@x200.localdomain> (Alexey Dobriyan's message of "Tue\, 31 Mar 2009 02\:53\:26 +0400")
Message-ID: <m1skkuhaik.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: adobriyan@gmail.com, linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

> I don't have a lot of opinion on this bug. I checked patchset to fix known
> reproducer, timeout is obviously taken out of air and not nice.

As for timeout.  The logic is that mark_mounts_for_expiry is just an
aging mechanism, and if something is actually in use it is not aged out.

In the general case the call to proc_shrink_automounts in
kernel/exit.c will clean up everything.  It is possible but unlikely
in practice that someone will pin a lot of process directories open
then stop pinning them, and after that point nothing will remain open,
so we close that hole.

I set timeout huge because it should never be needed in real life.

That said I'm up for taking this as a starting point and generalizing
the mechanisms in fs/namespace.c.  So I don't need a timeout at all,
but that is an orthogonal discussion.

Eric
