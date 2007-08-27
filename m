Return-Path: <linux-kernel-owner+w=401wt.eu-S1762470AbXH0QV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762470AbXH0QV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761227AbXH0QNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:13:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50680 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761210AbXH0QNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:13:33 -0400
Date: Mon, 27 Aug 2007 17:13:28 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Dean Nelson <dcn@sgi.com>
Cc: akpm@linux-foundation.org, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, tony.luck@intel.com,
       jes@sgi.com
Subject: Re: [PATCH 1/4] export __put_task_struct for XPMEM
Message-ID: <20070827161327.GG21089@ftp.linux.org.uk>
References: <20070827155622.GA25589@sgi.com> <20070827155933.GB25589@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827155933.GB25589@sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 10:59:33AM -0500, Dean Nelson wrote:
> This patch exports __put_task_struct as it is needed by XPMEM.
> 
> Signed-off-by: Dean Nelson <dcn@sgi.com>
> 
> ---
> 
> One struct file_operations registered by XPMEM, xpmem_open(), calls
> 'get_task_struct(current->group_leader)' and another, xpmem_flush(), calls
> 'put_task_struct(tg->group_leader)'.

Does it?  Well, then open the file in question and start doing close(dup(fd))
in a loop.  Won't take long for an oops...
