Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYFVCGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYFVCGl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 22:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbYFVCGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 22:06:33 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:45463 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751147AbYFVCGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 22:06:32 -0400
Message-ID: <485DB394.1040208@davidnewall.com>
Date: Sun, 22 Jun 2008 11:36:12 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: palani saravanan <busybeesaravanan0072003@yahoo.co.in>
CC: linux-kernel@vger.kernel.org
Subject: Re: Behavior of lseek() on a fd opened with 'RDONLY' flag, when seeking
 goes beyond file size.
References: <807740.19494.qm@web8703.mail.in.yahoo.com>
In-Reply-To: <807740.19494.qm@web8703.mail.in.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

palani saravanan wrote:
> Does lseek() permits -ve value as offset, with SEEK_SET mode? ...
>    errno = 0;
>    rd_rc = lseek(rd_fd, -10, SEEK_SET);
> returns rd_rc = -10 and errno remains 0.
>   

No, lseek does not permit negative file offsets, and should return
EINVAL in your example.  You may have discovered a bug.  For reference,
on my system lseek returns -1 and sets errno to EINVAL, as it should.

If you're running a recent kernel it might be worth looking closer into
this; for older kernels it's probably not worth the effort.
