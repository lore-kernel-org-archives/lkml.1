Return-Path: <linux-kernel-owner+w=401wt.eu-S934341AbXLPMPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934341AbXLPMPM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 07:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765507AbXLPMO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 07:14:57 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:63037 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbXLPMO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 07:14:56 -0500
To: david@davidnewall.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200712162026.BFJ01924.tOFJSFOQMVHOLF@I-love.SAKURA.ne.jp>
	<47650C88.6040105@davidnewall.com>
	<200712162036.JAJ09389.OQOVtOHMFLFSFJ@I-love.SAKURA.ne.jp>
	<476512F1.5010701@davidnewall.com>
	<200712162103.IEC69233.FFOFOOtJMQHSLV@I-love.SAKURA.ne.jp>
In-Reply-To: <200712162103.IEC69233.FFOFOOtJMQHSLV@I-love.SAKURA.ne.jp>
Message-Id: <200712162114.BJE04102.tOMFHOOFSJVQFL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 16 Dec 2007 21:14:54 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> But use of this filesystem is still valid when this filesystem is used with
> policy based mandatory access control (such as SELinux, TOMOYO Linux)
> because this filesystem guarantees where policy based mandatory access control
> can't guarantee (i.e. filename and its attribute).
> 
Policy based mandatory access control guarantees that
"Only Bob can create block device file named sda1 in /dev directory".
But it can't guarantee that /dev/sda1 will have block-8-1 attribute.
If Bob is malicious and creates /dev/sda1 with block-8-2 attribute,
other applications that depends on the attributes of /dev/sda1 goes wrong.
So, this filesystem guarantees that /dev/sda1 has block-8-1 attribute.
