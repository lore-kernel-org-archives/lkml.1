Return-Path: <linux-kernel-owner+w=401wt.eu-S1761541AbZBYX5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541AbZBYX5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbZBYX5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:57:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754119AbZBYX5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:57:32 -0500
Date: Wed, 25 Feb 2009 15:56:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       fweisbec@gmail.com, srostedt@redhat.com
Subject: Re: [PATCH 1/4] uaccess: add copy_word_from_user
Message-Id: <20090225155648.acb93cff.akpm@linux-foundation.org>
In-Reply-To: <20090225203427.382137706@goodmis.org>
References: <20090225203007.582030664@goodmis.org>
	<20090225203427.382137706@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

btw,

On Wed, 25 Feb 2009 15:30:08 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> +int copy_word_from_user(void *to, const void __user *from,
> +			unsigned int copy, unsigned int read,
> +			unsigned int *copied, int skip)

You presently have this not-exported-to-modules.  Was that deliberate?

There are arguments either way.  Lately we've tended to take the
position that a whole interface either is or is not wholly exported. 
The uaccess functions are exported, so this one should be as well.

We can of course do that later on, when there's a user - I have no
particular preference personally.

<looks at probe_kernel_read and probe_kernel_write>

These are really part of the uaccess interface too.  I don't see a need
for both lib/uaccess.c and mm/maccess.c?

probe_kernel_read() and probe_kernel_write() are EXPORT_SYMBOL_GPL,
whereas the rest of the uaccess interface is EXPORT_SYMBOL.  Ho hum.

