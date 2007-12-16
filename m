Return-Path: <linux-kernel-owner+w=401wt.eu-S934002AbXLPMDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934002AbXLPMDq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 07:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765013AbXLPMDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 07:03:31 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:61032 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932849AbXLPMDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 07:03:30 -0500
To: david@davidnewall.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <47650A4C.4000708@davidnewall.com>
	<200712162026.BFJ01924.tOFJSFOQMVHOLF@I-love.SAKURA.ne.jp>
	<47650C88.6040105@davidnewall.com>
	<200712162036.JAJ09389.OQOVtOHMFLFSFJ@I-love.SAKURA.ne.jp>
	<476512F1.5010701@davidnewall.com>
In-Reply-To: <476512F1.5010701@davidnewall.com>
Message-Id: <200712162103.IEC69233.FFOFOOtJMQHSLV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 16 Dec 2007 21:03:27 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

David Newall wrote:
> > You won't be able to login to the system because /sbin/mingetty
> > fails to "chown/chmod" /dev/tty* if /dev is mounted for read-only mode.
> 
> Good point.  So, if only root can modify files in /dev, what's the 
> problem you're fixing?  (I'm sure you tried to explain this in your 
> original post, but your reasons weren't clear to me.)

In 2003, I was trying to make / partition read-only to avoid tampering system files.
Use of policy based mandatory access control (such as SELinux) is
one of ways to avoid tampering, but management of policy was a daunting task.
So, I tried to store / partition in a read-only medium so that
the system is free from tampering system files.

When I attended at Security Stadium 2003 as a defense side,
I was using devfs for /dev directory. The files in /dev directory
were deleted by attckers and the administrator was unable to login.
So I developed this filesystem so that attackers who got root privilege
can't tamper files in /dev directory.
Not many systems mount / partition for read-only mode,
thus there may be few needs for read-only / partition.

But use of this filesystem is still valid when this filesystem is used with
policy based mandatory access control (such as SELinux, TOMOYO Linux)
because this filesystem guarantees where policy based mandatory access control
can't guarantee (i.e. filename and its attribute).
