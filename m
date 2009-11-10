Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZKJRW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZKJRW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZKJRW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:22:26 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56142 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752773AbZKJRWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:22:25 -0500
Date: Tue, 10 Nov 2009 17:23:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bryan Donlan <bdonlan@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Timo Sirainen <tss@iki.fi>, Ulrich Drepper <drepper@redhat.com>,
       WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: + prctl-add-pr_set_proctitle_area-option.patch added to -mm
 tree
Message-ID: <20091110172337.2236ad58@lxorguk.ukuu.org.uk>
In-Reply-To: <20091110170453.GA11771@redhat.com>
References: <20091110170453.GA11771@redhat.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, we can't do access_process_vm() under ->mmap_sem, but we can add
> the new helper, say, access_process_vm_locked(tsk, mm, ...) which does
> the actual work. Then proc_pid_cmdline() can take mmap_sem for reading,
> read arg_start/arg_end and call access_process_vm_locked().

It might not be a bad idea if whoever wrote it spent about 60 seconds
thinking about maths overflow as well. I'm not sure some of the tools
will react too well if end is before start.
