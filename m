Return-Path: <linux-kernel-owner+w=401wt.eu-S1752182AbZA3JVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbZA3JVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:21:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZA3JU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:20:57 -0500
Received: from tundra.namei.org ([65.99.196.166]:3477 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbZA3JU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:20:56 -0500
Date: Fri, 30 Jan 2009 20:18:34 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "<David Safford" <safford@watson.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 3/6] integrity: IMA display
In-Reply-To: <d92bfa1d386febc0f56c80204203a43d63d42d02.1233262163.git.zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.1.10.0901302013200.31987@tundra.namei.org>
References: <cover.1233262162.git.zohar@linux.vnet.ibm.com> <d92bfa1d386febc0f56c80204203a43d63d42d02.1233262163.git.zohar@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009, Mimi Zohar wrote:

> +int ima_fs_init(void)
> +{
> +	ima_dir = securityfs_create_dir("ima", NULL);
> +	if (!ima_dir || IS_ERR(ima_dir))
> +		return -1;
> +
> +	binary_runtime_measurements =
> +	    securityfs_create_file("binary_runtime_measurements",
> +				   S_IRUSR | S_IRGRP, ima_dir, NULL,
> +				   &ima_measurements_ops);
> +	if (!binary_runtime_measurements || IS_ERR(binary_runtime_measurements))
> +		goto out;

You should not be checking for NULL returns from securityfs_create_file(), 
because it does not return NULL (the documentation is wrong).


- James
-- 
James Morris
<jmorris@namei.org>
