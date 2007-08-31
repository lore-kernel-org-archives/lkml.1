Return-Path: <linux-kernel-owner+w=401wt.eu-S1760295AbXHaUC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbXHaUC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 16:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbXHaUCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 16:02:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55824 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752091AbXHaUCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 16:02:49 -0400
Date: Fri, 31 Aug 2007 13:02:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [-mm PATCH]  Memory controller improve user interface (v2)
Message-Id: <20070831130216.226db806.akpm@linux-foundation.org>
In-Reply-To: <20070830185246.3170.74806.sendpatchset@balbir-laptop>
References: <20070830185246.3170.74806.sendpatchset@balbir-laptop>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007 00:22:46 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> +/*
> + * Strategy routines for formating read/write data
> + */
> +int mem_container_read_strategy(unsigned long long val, char *buf)
> +{
> +	return sprintf(buf, "%llu Bytes\n", val);
> +}

It's a bit cheesy to be printing the units like this.  It's better to just
print the raw number.

If you really want to remind the user what units that number is in (not a
bad idea) then it can be encoded in the filename, like
/proc/sys/vm/min_free_kbytes, /proc/sys/vm/dirty_expire_centisecs, etc.


> +int mem_container_write_strategy(char *buf, unsigned long long *tmp)
> +{
> +	*tmp = memparse(buf, &buf);
> +	if (*buf != '\0')
> +		return -EINVAL;
> +
> +	printk("tmp is %llu\n", *tmp);

don't think we want that.

> +	/*
> +	 * Round up the value to the closest page size
> +	 */
> +	*tmp = ((*tmp + PAGE_SIZE - 1) >> PAGE_SHIFT) << PAGE_SHIFT;
> +	return 0;
> +}
