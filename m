Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297Ab0BXWDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 17:03:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758174Ab0BXWDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 17:03:08 -0500
Date: Wed, 24 Feb 2010 14:01:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>
Cc: "Serge E . Hallyn" <serue@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 0/6] Fix file descriptor leak on user-space processes
 and cleanup
Message-Id: <20100224140158.4f4dba78.akpm@linux-foundation.org>
In-Reply-To: <cover.1266907495.git.andre.goddard@gmail.com>
References: <cover.1266907495.git.andre.goddard@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010 04:04:22 -0300 Andr__ Goddard Rosa <andre.goddard@gmail.com> wrote:

> Fix a file descriptor leak on user-space processes and perform a cleanup,
> reducing the code size:
> text    data     bss     dec     hex filename
> 9949      72      16   10037    2735 ipc/mqueue-BEFORE.o
> 9885      72      16    9973    26f5 ipc/mqueue-AFTER.o
> 
> Andr__ Goddard Rosa (6):
>   mqueue: remove unneeded info->messages initialization
>   mqueue: apply mathematics distributivity on mq_bytes calculation
>   mqueue: simplify do_open() error handling
>   mqueue: only set error codes if they are really necessary
>   mqueue: fix typo "failues" -> "failures"
>   mqueue: fix mq_open() file descriptor leak on user-space processes

Fixing the leak is far more important than the other five patches, and
we'll want to backport the leak fix into earlier kernels.  So the
bugfix patch should have been the first in the series!

So I've reordered the patches in that fashion and shall tag "mqueue:
fix mq_open() file descriptor leak on user-space processes" as needing
-stable backporting.

The patches apply and build OK with that reordering, but please do
double-check it, thanks.

