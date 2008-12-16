Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759507AbYLPXuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbYLPXuk (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 18:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbYLPXua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 18:50:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753485AbYLPXu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 18:50:29 -0500
Date: Tue, 16 Dec 2008 15:49:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
        mingo@elte.hu, rostedt@goodmis.org
Subject: Re: [PATCH 0/9] oprofile: port to the new ring buffer
Message-Id: <20081216154920.d6b922bb.akpm@linux-foundation.org>
In-Reply-To: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
References: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 17:41:54 +0100
Robert Richter <robert.richter@amd.com> wrote:

> This patch set ports cpu buffers in oprofile to the new ring buffer
> provided by the tracing framework.

alpha allmodconfig:

arch/alpha/oprofile/../../../drivers/oprofile/buffer_sync.c: In function 'sync_buffer':
arch/alpha/oprofile/../../../drivers/oprofile/buffer_sync.c:398: warning: 'offset' may be used uninitialized in this function
make[1]: *** [arch/alpha/oprofile/../../../drivers/oprofile/buffer_sync.o] Error 1                                                    

because stupid gcc thinks that

	lookup_dcookie(mm, s->eip, &offset);

didn't initialise `offset', and arch/alpha is compiled with -Werror.

I'm not sure what to do about that, apart from finding (or building) a
new alpha cross-compiler.

What a PITA.   I do so wish that someone would maintain a suite of
cross-compilers for kernel developers.
