Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbXKUTHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbXKUTHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 14:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbXKUTGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 14:06:49 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:44159 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582AbXKUTGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 14:06:48 -0500
Message-ID: <474481B9.9000603@oracle.com>
Date: Wed, 21 Nov 2007 11:06:33 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
CC: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]loop cleanup in fs/namespace.c - repost
References: <47447184.6040805@gmail.com>
In-Reply-To: <47447184.6040805@gmail.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The patch given below replaces the goto-loop by a while-based one.

That certainly looks fine.  I would also replace the 'return' with
'break', but I guess that's more of a question of personal preference.

> Besides, it removes the export for the same routine, because there are
> no users for it outside of the core VFS code.

This doesn't look fine.  Did you test this?

mntput_no_expire() is called from mntput() which is an inline function
in mount.h.  So lots of callers of mntput() in modules will end up
trying to call mntput_no_expire() from modules.

$ nm fs/fuse/fuse.ko | grep mntput_no_expire
                 U mntput_no_expire

- z
