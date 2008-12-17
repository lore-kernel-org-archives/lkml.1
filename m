Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760621AbYLQH5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621AbYLQH5a (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759406AbYLQH5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:57:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759622AbYLQH5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:57:15 -0500
Date: Tue, 16 Dec 2008 23:56:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/15] sanitize AUDIT_MQ_SENDRECV
Message-Id: <20081216235656.d7985f1d.akpm@linux-foundation.org>
In-Reply-To: <E1LCohe-0000C7-TH@ZenIV.linux.org.uk>
References: <E1LCohe-0000C7-TH@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008 05:12:10 +0000 Al Viro <viro@ftp.linux.org.uk> wrote:

> 
> * logging the original value of *msg_prio in mq_timedreceive(2)
>   is insane - the argument is write-only (i.e. syscall always
>   ignores the original value and only overwrites it).
> * merge __audit_mq_timed{send,receive}
> * don't do copy_from_user() twice
> * don't mess with allocations in auditsc part
> * ... and don't bother checking !audit_enabled and !context in there -
>   we'd already checked for audit_dummy_context().
> 
> ...
>
> +		if (copy_from_user(&ts, u_abs_timeout, 
> +					sizeof(struct timespec)))

Well that's odd.  afacit timespec has different sizes on 32-bit and
64-bit userspace.

But the old audit code did this copy too, and it presumably worked.
