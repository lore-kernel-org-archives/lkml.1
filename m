Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbXE3SSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbXE3SSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 14:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbXE3SSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 14:18:03 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753408AbXE3SSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 14:18:01 -0400
Date: Wed, 30 May 2007 11:17:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH][RFC] security: revalidate rw permissions for sys_splice
 and  sys_vmsplice
Message-Id: <20070530111743.e638c841.akpm@linux-foundation.org>
In-Reply-To: <20070530071500.GU15559@kernel.dk>
References: <Line.LNX.4.64.0705291617260.9955@d.namei>
	<20070530071500.GU15559@kernel.dk>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 09:15:01 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Tue, May 29 2007, James Morris wrote:
> > Revalidate read/write permissions for splice(2) and vmslice(2), in case 
> > security policy has changed since the files were opened.
> 
> I guess it was inevitably going to happen :-)
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> 

Probably acked-by was more appropriate.

James, is this considered needed-for-2.6.22?

> +	ret = security_file_permission(out, MAY_WRITE);
> +	if (unlikely(ret < 0))
> +		return ret;


ot: all the unlikely()s are irksome.  I wonder if there was some way of
doing this in security_file_permission() instead.  eg:

static inline int security_file_permission (struct file *file, int mask)
{
	int ret = security_ops->file_permission (file, mask);

	if (likely(ret == 0))
		return 0;
	return ret;
}
