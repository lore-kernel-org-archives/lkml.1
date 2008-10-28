Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYJ1Vmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYJ1Vmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 17:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYJ1Vmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 17:42:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595AbYJ1Vmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 17:42:40 -0400
Date: Tue, 28 Oct 2008 14:42:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: menage@google.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] oom: print triggering task's cpuset and mems allowed
Message-Id: <20081028144234.35924bad.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0810280222090.31219@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810241704380.15988@chino.kir.corp.google.com>
	<alpine.DEB.1.10.0810241714290.16902@chino.kir.corp.google.com>
	<20081027174136.c97687c7.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0810280222090.31219@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008 09:08:15 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> +#define CPUSET_NAME_LEN		(128)
> +#define	CPUSET_NODELIST_LEN	(256)
> +static char cpuset_name[CPUSET_NAME_LEN];
> +static char cpuset_nodelist[CPUSET_NODELIST_LEN];
>
> ...
>
> +	snprintf(cpuset_name, CPUSET_NAME_LEN,
> +		 dentry ? (const char *)dentry->d_name.name : "/");

nit: this requires that the reviewer (and the maintainer) ensure that
CPUSET_NAME_LEN=sizeof(cpuset_name).  This must be done manually and
introduces risk.

Better would be:


static char cpuset_name[128];

...

	snprintf(cpuset_name, sizeof(cpuset_name), ...);

