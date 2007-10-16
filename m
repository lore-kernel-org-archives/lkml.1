Return-Path: <linux-kernel-owner+w=401wt.eu-S1760809AbXJPJDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760809AbXJPJDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 05:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755923AbXJPJDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 05:03:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42296 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755667AbXJPJDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 05:03:11 -0400
Date: Tue, 16 Oct 2007 02:01:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: Possible circular locking: ->mmap_sem vs jbd_handle
Message-Id: <20071016020159.5cff8976.akpm@linux-foundation.org>
In-Reply-To: <20071016085429.GA6352@localhost.sw.ru>
References: <20071016085429.GA6352@localhost.sw.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 12:54:29 +0400 Alexey Dobriyan <adobriyan@sw.ru> wrote:

> Got this during LTP's diotest1. Reproducable.
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.23-65a6ec0d72a07f16719e9b7a96e1c4bae044b591 #2
> -------------------------------------------------------
> diotest1/13563 is trying to acquire lock:
>  (&mm->mmap_sem){----}, at: [<c107a7b7>] dio_get_page+0x4b/0x16b
> 
> but task is already holding lock:
>  (jbd_handle){--..}, at: [<c1099b05>] journal_start+0xf3/0x120
> 
> which lock already depends on the new lock.

Someone taught lockdep about journal_start?  That's gonna hurt.
