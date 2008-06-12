Return-Path: <linux-kernel-owner+w=401wt.eu-S1761156AbYFLXQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761156AbYFLXQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 19:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYFLXQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 19:16:08 -0400
Received: from [194.117.236.238] ([194.117.236.238]:47230 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbYFLXQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 19:16:07 -0400
Date: Fri, 13 Jun 2008 02:15:42 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: righi.andrea@gmail.com
Cc: tzanussi@gmail.com, penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       compudj@krystal.dyndns.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] relay: Fix race condition which occurs when reading
 across CPUs.
Message-ID: <20080613021542.6ca9e6b5@linux360.ro>
In-Reply-To: <4851A9FA.1000104@gmail.com>
References: <20080612232618.647f5cda@linux360.ro>
	<4851A9FA.1000104@gmail.com>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008 00:58:01 +0200 (MEST)
Andrea Righi <righi.andrea@gmail.com> wrote:

> If you just break here buf->rw_lock will be unlocked twice. Maybe a
> better way is:
> 		if (desc->error < 0)
> 			goto out;
> 		...
>   	} while (desc->count && ret);
> 	spin_unlock_irqrestore(&buf->rw_lock, flags);
> out:
>   	mutex_unlock(&filp->f_path.dentry->d_inode->i_mutex);
> 
>   	return desc->written;

Thanks, I did not notice. Will fix and resubmit.


	Eduard
