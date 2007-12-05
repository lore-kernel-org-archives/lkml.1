Return-Path: <linux-kernel-owner+w=401wt.eu-S1757103AbXLETva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbXLETva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbXLETlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:41:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:52856 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbXLETlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:41:01 -0500
To: Dave Anderson <anderson@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exec: allow > 2GB executables to run on 64-bit systems
From: Andi Kleen <andi@firstfloor.org>
References: <4756C590.9080301@redhat.com>
Date: Wed, 05 Dec 2007 20:41:00 +0100
In-Reply-To: <4756C590.9080301@redhat.com> (Dave Anderson's message of "Wed\, 05 Dec 2007 10\:36\:48 -0500")
Message-ID: <p73fxyhj5f7.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Anderson <anderson@redhat.com> writes:

> When a executable that is greater than 2GB in size is attempted on a 64-bit
> system on a file system that calls, or uses generic_file_open() as its
> open handler, it fails with an EOVERFLOW erro.  This patch adds a call
> to force_o_largefile() call in open_exec(), as done in sys_open() and
> sys_openat().

Wouldn't it be better to just always pass O_LARGEFILE unconditionally
there? e.g. in theory a 2.5GB executable should work on i386 and binfmt_*
shouldn't have any problems with a large file.
That would simplify your patch.

-Andi

