Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbYFYWe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbYFYWe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 18:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYFYWeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 18:34:21 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:36028 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbYFYWeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 18:34:21 -0400
To: Joe Peterson <joe@skyrush.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
From: Andi Kleen <andi@firstfloor.org>
References: <4861D685.4070308@skyrush.com>
Date: Thu, 26 Jun 2008 00:33:43 +0200
In-Reply-To: <4861D685.4070308@skyrush.com> (Joe Peterson's message of "Tue, 24 Jun 2008 23:24:21 -0600")
Message-ID: <87od5pqh4o.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Jun 2008 22:26:26.0830 (UTC) FILETIME=[81DEBAE0:01C8D712]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Peterson <joe@skyrush.com> writes:

> Attached is a patch to provide a new mount option ("utc") for DOS
> (vfat/msdos) filesystems, allowing timestamps to be in universal
> coordinated time (UTC) rather than local time in applications where
> doing this is advantageous.

The time zone handling seems racy. e.g. consider the case DST 
changes on that day. You convert before the switch over 
and suddenly the time offset is different.

I'm actually not sure someone in user space is even updating the kernel
idea of the timezone for DST on a switch (generally it was assumed it's some
obsolete BSD concept and that all real programs only use the 
user space glibc implementation that knows all the rules). So 
DST might not be supported at all.

Also even if it worked it seems very limited. If you do that why not
have an option to set an arbitary time zone offset?

-Andi
