Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbYJWDX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbYJWDX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 23:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbYJWDXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 23:23:48 -0400
Received: from saeurebad.de ([85.214.36.134]:48680 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbYJWDXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 23:23:48 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Andrea Righi <righi.andrea@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: lockdep splat from fbmem
Date: Thu, 23 Oct 2008 05:23:38 +0200
Message-ID: <87ljwgj8p1.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

fb_mmap() is called under mmap_sem and acquires fb_info->lock.

Since 3e680aae4e53ab "fb: convert lock/unlock_kernel() into local fb
mutex", fb_ioctl() takes fb_info->lock and does copy_to/from_user()
under it, which in turn might acquire mmap_sem.

Just noticed the trace and wanted to let you know.

        Hannes
