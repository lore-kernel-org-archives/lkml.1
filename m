Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbZD2Vtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbZD2Vtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZD2Vtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:49:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbZD2Vtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:49:41 -0400
Date: Wed, 29 Apr 2009 14:46:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: peterz@infradead.org, rientjes@google.com, david@fromorbit.com,
       cl@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: prevent divide error for small values of
 vm_dirty_bytes
Message-Id: <20090429144655.e60fdf7a.akpm@linux-foundation.org>
In-Reply-To: <20090429093449.GB3151@linux>
References: <1240993759-30787-1-git-send-email-righi.andrea@gmail.com>
	<1240994676.8021.83.camel@laptop>
	<20090429093449.GB3151@linux>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 11:34:51 +0200
Andrea Righi <righi.andrea@gmail.com> wrote:

> --- a/Documentation/sysctl/vm.txt
> +++ b/Documentation/sysctl/vm.txt
> @@ -90,6 +90,10 @@ will itself start writeback.
>  If dirty_bytes is written, dirty_ratio becomes a function of its value
>  (dirty_bytes / the amount of dirtyable system memory).
>  
> +Note: the minimum value allowed for dirty_bytes is two pages (in bytes); any
> +value lower than this limit will be ignored and the old configuration will be
> +retained.

Well.  This implies that the write to the procfs file would appear to
succeed.  One hopes that the write would in fact return -EINVAL or
such?
