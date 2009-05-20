Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbZETN6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbZETN6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 09:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZETN63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 09:58:29 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:43829 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbZETN62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 09:58:28 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: inotify limits - thousands (tens of thousands?) of watches 
To: Marcin Krol <mrkafk@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4A13CCE1.5000106@gmail.com>
References: <4A13CCE1.5000106@gmail.com>
Date: Wed, 20 May 2009 22:58:26 +0900
Message-ID: <8255.1242827906@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Marcin Krol:
> I'm not a kernel programmer, but I want to develop a program that would 
> watch modifications in *all* user directories on a busy server using 
> inotify.
	:::
> 1. is it safe? that is, will it not lock the kernel up, or cause 
> excessive memory consumption?
> 
> 2. is it economic in terms of CPU time and RAM? I have no idea how to 
> even measure such a thing happening in the kernel..

The maximum number of inotify instances per user is limited to
/proc/sys/fs/inotify/max_user_instances which is 128 by default.
And also the number of watches per user is limited by
/proc/sys/fs/inotify/max_user_watches (8192 by defaut).
Theoretically you may be able to monitor 8192 directories, but it
consumes memory.

If periodical rsync is out of question for you, how about kprobe?
While I don't think it is a beautiful solution, to set a hook to
vfs_mkdir, vfs_unlink, etc and to compare the target super_block may
work for you.
See Documentation/kprobe.txt in detail.


J. R. Okajima
