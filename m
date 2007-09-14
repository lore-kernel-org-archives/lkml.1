Return-Path: <linux-kernel-owner+w=401wt.eu-S1760969AbXINBiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760969AbXINBiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 21:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbXINBhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 21:37:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50176 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332AbXINBhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 21:37:54 -0400
Date: Thu, 13 Sep 2007 18:37:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Oliver Neukum <oliver@neukum.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] [-mm] FS: file name must be unique in the same dir in
 procfs
Message-Id: <20070913183744.7e074852.akpm@linux-foundation.org>
In-Reply-To: <1189493003.22038.30.camel@localhost.localdomain>
References: <1187605699.2920.147.camel@acpi-hp.sh.intel.com>
	<200708201245.17780.oliver@neukum.org>
	<1187625005.2920.167.camel@acpi-hp.sh.intel.com>
	<20070910004927.323763ad.akpm@linux-foundation.org>
	<1189493003.22038.30.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> From: Zhang Rui <rui.zhang@intel.com>
> File name should be unique in the same directory.
> 
> In order to keep the back-compatibility, only a warning is given
> currently, but actions must be taken to fix it when such duplicates
> are detected.
> 
> Bug report and a simple fix can be found here: 
> http://bugzilla.kernel.org/show_bug.cgi?id=8798
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  fs/proc/generic.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> Index: linux-2.6/fs/proc/generic.c
> ===================================================================
> --- linux-2.6.orig/fs/proc/generic.c
> +++ linux-2.6/fs/proc/generic.c
> @@ -523,6 +523,7 @@ static const struct inode_operations pro
>  
>  static int proc_register(struct proc_dir_entry * dir, struct
> proc_dir_entry * dp)

Your email client is wordwrapping the text.

>  {
> +	struct proc_dir_entry *tmp = NULL;

That initialisation is unneeded - I removed it.

`tmp' is always a crappy name for anything.  I renamed it to `de'.


