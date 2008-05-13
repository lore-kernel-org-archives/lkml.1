Return-Path: <linux-kernel-owner+w=401wt.eu-S1761978AbYEMUOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761978AbYEMUOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759880AbYEMUNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:13:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759699AbYEMUND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:13:03 -0400
Date: Tue, 13 May 2008 13:11:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: menage@google.com
Cc: pj@sgi.com, xemul@openvz.org, balbir@in.ibm.com, serue@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC/PATCH 6/8]: CGroup Files: Remove
 cpuset_common_file_write()
Message-Id: <20080513131134.8b1cefe2.akpm@linux-foundation.org>
In-Reply-To: <20080513071522.984545000@menage.corp.google.com>
References: <20080513063707.049448000@menage.corp.google.com>
	<20080513071522.984545000@menage.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2008 23:37:13 -0700
menage@google.com wrote:

> @@ -1412,14 +1355,18 @@ static struct cftype files[] = {
>  	{
>  		.name = "cpus",
>  		.read = cpuset_common_file_read,
> -		.write = cpuset_common_file_write,
> +		.write_string = update_cpumask,
> +		.max_write_len = (100U + 6 * NR_CPUS),

hm, magic handwavy surely-enough-for-anyone constants.

What's going on here?

> +		.lockmode = CFT_LOCK_CGL_WRITE,
>  		.private = FILE_CPULIST,
>  	},
