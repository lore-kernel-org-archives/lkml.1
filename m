Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbYJWN6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbYJWN6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbYJWN6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:58:21 -0400
Received: from saeurebad.de ([85.214.36.134]:56450 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530AbYJWN6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:58:20 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrea Righi <righi.andrea@gmail.com>, Dave Jones <davej@redhat.com>,
       Dave Airlie <airlied@redhat.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: lockdep splat from ioctl and mmap fops sharing lock
References: <87ljwgj8p1.fsf@saeurebad.de>
Date: Thu, 23 Oct 2008 15:58:10 +0200
In-Reply-To: <87ljwgj8p1.fsf@saeurebad.de> (Johannes Weiner's message of "Thu,
	23 Oct 2008 05:23:38 +0200")
Message-ID: <87ej27jtvx.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@saeurebad.de> writes:

> Hi,
>
> fb_mmap() is called under mmap_sem and acquires fb_info->lock.
>
> Since 3e680aae4e53ab "fb: convert lock/unlock_kernel() into local fb
> mutex", fb_ioctl() takes fb_info->lock and does copy_to/from_user()
> under it, which in turn might acquire mmap_sem.

More affected drivers:

agp_ioctl() doing usercopy under agp_fe.agp_mutex
agp_mmap() taking agp_fe.agp_mutex under mmap_sem

dv1394_write() doing usercopy under video->mtx
dv1394_mmap() taking video->mtx under mmap_sem

raw1394_ioctl() doing usercopy under fi->state_mutex
raw1394_mmap() taking fi->state_mutex under mmap_sem

	Hannes
