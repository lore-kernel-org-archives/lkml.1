Return-Path: <linux-kernel-owner+w=401wt.eu-S1752325AbZJKVvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbZJKVvL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 17:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZJKVvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 17:51:08 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:53477 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbZJKVvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 17:51:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=BrvMAXhxUyAIVs62lsha97Ni9VMlk595bjE23BwO8X++beYnLqsNeAhTwx0W0T0GJN
         5pFdk1Z+mYTbPtBibtWQw31IvR6hxVFEpHnRE9N25jC9jp7zhvqT/Ewdj3Z5sAQoS+BF
         TB/qSly81aeuWp6fYadzxviM83Sxzdz6WdiwI=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch 11/28] nvram: Drop the bkl from nvram_llseek()
Date: Sun, 11 Oct 2009 23:50:24 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: Arnd Bergmann <arndbergmann@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       "Sven-Thorsten Dietrich" <sven@thebigcorporation.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <gregkh@suse.de>
References: <20091010153314.827301943@linutronix.de> <20091011210809.GC5486@nowhere> <20091011214053.GD5486@nowhere>
In-Reply-To: <20091011214053.GD5486@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910112350.24870.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 October 2009, Frederic Weisbecker wrote:
> Now I'm adding the ioctl() sites too:
> 
> git-grep "\.ioctl *=" | grep -P "^\S+\.c" | wc -l
> 452
> 
> Hehe :)

Not all of them, fortunately.

There are various *_operations structures that have a .ioctl pointer.
While there are a lot of struct file_operations with a locked .ioctl
operation, stuff like block_device_operations does not hold the
BKL in .ioctl but in .locked_ioctl.

	Arnd <><
