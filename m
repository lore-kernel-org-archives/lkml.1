Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbYJELki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbYJELki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 07:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbYJELka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 07:40:30 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37785 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752920AbYJELk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 07:40:29 -0400
Message-Id: <1223206828.13684.1277591179@webmail.messagingengine.com>
X-Sasl-Enc: 852Ck5IjdO3hSEeO3EwylwxAcROXodghb3JmznEAsBA2 1223206828
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1223154766-19350-1-git-send-email-heukelum@fastmail.fm>
 <20081005093523.GE16819@elte.hu>
Subject: Re: [PATCH] dumpstack: x86: various small unification steps
In-Reply-To: <20081005093523.GE16819@elte.hu>
Date: Sun, 05 Oct 2008 13:40:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2008 11:35:23 +0200, "Ingo Molnar" <mingo@elte.hu> said:
> [...]
> 
> regarding klibc, that's interesting: is that the in-kernel klibc from 
> hpa? Which tree are you using to pull that into tip/master? (unless i 
> misunderstood what you are doing)

Hi,

I just use hpa's git://git.kernel.org/pub/scm/libs/klibc/klibc.git,
and compile it 'stand-alone' (you need to create a symlink 'linux',
pointing to a configured kernel tree first.)

I put the klibc-library and all the binaries in the kernel-built-in
initramfs and add an 'init', which contains:

#! /bin/sh
mkdir proc
mount -t proc proc /proc
mkdir sys
mount -t sysfs sysfs /sys
mkdir debugfs
mount -t debugfs debugfs /debugfs
bin/sh -i
reboot

This way even the simplest test-kernel gets into userspace and
you can examine the contents of proc and sysfs.

As hpa is listening too... I have a feature request for klibc
to auto-generate a file that can be fed to the kernel's
INITRAMFS_SOURCE, containing all binaries and an init like
the one I gave above. Especially because the hash added to
the shared library name keeps changing :-/.

Adding a (staticly linked) binary for testing is then an
easy way to run a test in userspace. And usually I do that
using qemu.

Greetings,
    Alexander

> 	Ingo
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - One of many happy users:
  http://www.fastmail.fm/docs/quotes.html

