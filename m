Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbZEANHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbZEANHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbZEANHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:07:35 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:53404 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbZEANHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:07:34 -0400
To: pavel@ucw.cz
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [TOMOYO 1/2] tomoyo: add Documentation/tomoyo.txt
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20090408133126.180521064@I-love.SAKURA.ne.jp>
	<20090408133524.395437925@I-love.SAKURA.ne.jp>
	<20090410171001.GA26156@elf.ucw.cz>
	<200904130204.n3D24JNk095583@www262.sakura.ne.jp>
	<20090501102438.GA7470@elf.ucw.cz>
In-Reply-To: <20090501102438.GA7470@elf.ucw.cz>
Message-Id: <200905012207.BFC60616.QStOHOMJFOLFFV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 1 May 2009 22:07:31 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delayed response.

Pavel Machek wrote:
> 2.5 Memory Allocation Rules
> 
> In TOMOYO Linux, memory allocated for holding access permissions and
> words are never freed. There is no way except rebooting the system
> that can free unneeded memory.
> 
> But don't worry. The policy seldom changes after you start production
> mode. By tuning policy before starting production mode, you can reduce
> memory usage to (usually) less than 1 MB.
> 
> ....does that mean that it leaks memory by design?

This is memory leak, but *controlled* memory allocation with a strategy for
avoiding memory fragmentation and reducing memory usage. kstrdup()ing string
data produces partially unused memory block since string data's length is
unlikely power of two. Therefore, TOMOYO allocates memory in PAGE_SIZE bytes
block and embeds string data as much as possible.
TOMOYO does not continue allocating forever.
