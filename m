Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbYDOGjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbYDOGjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 02:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYDOGjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 02:39:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752420AbYDOGjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 02:39:05 -0400
Date: Mon, 14 Apr 2008 23:38:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] proc: convert /proc/tty/ldiscs to seq_file interface
Message-Id: <20080414233816.22d9be53.akpm@linux-foundation.org>
In-Reply-To: <20080412205923.GA9151@martell.zuzino.mipt.ru>
References: <20080412205923.GA9151@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 00:59:23 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> @@ -224,7 +239,6 @@ void __init proc_tty_init(void)
>  	 * entry.
>  	 */
>  	proc_tty_driver = proc_mkdir_mode("tty/driver", S_IRUSR | S_IXUSR, NULL);
> -
> -	create_proc_read_entry("tty/ldiscs", 0, NULL, tty_ldiscs_read_proc, NULL);
> +	proc_create("tty/ldiscs", 0, NULL, &tty_ldiscs_proc_fops);
>  	proc_create("tty/drivers", 0, NULL, &proc_tty_drivers_operations);
>  }

hm.  proc_tty_init() used to check for _some_ procfs API failures.  Now it
doesn't do any checking at all.
