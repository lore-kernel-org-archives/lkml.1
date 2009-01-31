Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZAaLkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZAaLkA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 06:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbZAaLjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 06:39:52 -0500
Received: from ozlabs.org ([203.10.76.45]:56045 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbZAaLjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 06:39:51 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/4] kthreads: simplify the startup synchronization
Date: Sat, 31 Jan 2009 22:09:40 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Vitaliy Gusev <vgusev@openvz.org>, linux-kernel@vger.kernel.org
References: <20090130123354.GA26213@redhat.com>
In-Reply-To: <20090130123354.GA26213@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901312209.41548.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 January 2009 23:03:54 Oleg Nesterov wrote:
> We use two completions two create the kernel thread, this is a bit ugly.
> kthread() wakes up create_kthread() via ->started, then create_kthread()
> wakes up the caller kthread_create() via ->done. But kthread() does not
> need to wait for kthread(), it can just return. Instead kthread() itself
> can wake up the caller of kthread_create().
> 
> Kill kthread_create_info->started, ->done is enough. This improves the
> scalability a bit and sijmplifies the code.
> 
> The only problem if kernel_thread() fails, in that case create_kthread()
> must do complete(&create->done).
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Nice!  I'll apply this one after the minor respin of 1/4.

Thanks,
Rusty.
