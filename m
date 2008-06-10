Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbYFJRmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbYFJRmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbYFJRmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:42:32 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:55960 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746AbYFJRmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:42:31 -0400
Subject: Re: [RFC PATCH 3/5] mgmcg VM overcommit interface
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com, containers@lists.osdl.org,
       menage@google.com, xemul@openvz.org
In-Reply-To: <1213054383-18137-4-git-send-email-righi.andrea@gmail.com>
References: <>  <1213054383-18137-4-git-send-email-righi.andrea@gmail.com>
Content-Type: text/plain
Date: Tue, 10 Jun 2008 10:42:26 -0700
Message-Id: <1213119746.13882.15.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-10 at 01:33 +0200, Andrea Righi wrote:
> 
> +       cgroup_unlock();
> +
> +       count = sprintf(page, "CommitLimit:  %8lu kB\n"
> +                             "Committed_AS: %8lu kB\n",
> +                             K(allowed), K(committed));
> +       ret = simple_read_from_buffer(userbuf, nbytes, ppos, page, count);
> +out:
> +       free_page((unsigned long)page);
> +       return ret;
> +}

I know you're trying to make this look like meminfo, but it does butcher
the sysfs rules a bit.  How about breaking it out into a couple of
files?

-- Dave

