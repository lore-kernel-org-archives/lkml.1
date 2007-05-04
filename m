Return-Path: <linux-kernel-owner+w=401wt.eu-S1030241AbXEDPe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030241AbXEDPe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030419AbXEDPev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:34:51 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:59726 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030241AbXEDPeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:34:50 -0400
Date: Fri, 4 May 2007 17:34:46 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: James Pearson <james-p@moving-picture.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Don't truncate /proc/PID/environ at 4096 characters
Message-Id: <20070504173446.7ff0baef.dada1@cosmosbay.com>
In-Reply-To: <463B43A1.6050409@moving-picture.com>
References: <463B43A1.6050409@moving-picture.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 May 2007 15:30:57 +0100
James Pearson <james-p@moving-picture.com> wrote:

> /proc/PID/environ currently truncates at 4096 characters, patch based on 
> the /proc/PID/mem code.
> 
> Signed-off-by: James Pearson <james-p@moving-picture.com>
>

What about latency when reading one *big* environ ?

Dont we need some cond_resched() test in the loop ?

> +
> +static struct file_operations proc_environ_operations = {
> +       .read           = environ_read,
> +};
> +

Please use the const qualifier here :

static const struct file_operations ...

Thank you

