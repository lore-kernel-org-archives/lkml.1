Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbYGFLl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbYGFLl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 07:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYGFLlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 07:41:51 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:23296 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbYGFLlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 07:41:50 -0400
To: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH] loop: prevent get_user pages call from kernel thread(v2)
From: Andi Kleen <andi@firstfloor.org>
References: <1215278340-3509-1-git-send-email-dmonakhov@openvz.org>
Date: Sun, 06 Jul 2008 13:40:44 +0200
In-Reply-To: <1215278340-3509-1-git-send-email-dmonakhov@openvz.org> (Dmitri Monakhov's message of "Sat,  5 Jul 2008 21:19:00 +0400")
Message-ID: <87tzf3qlz7.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Jul 2008 11:33:22.0329 (UTC) FILETIME=[18A1A090:01C8DF5C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitri Monakhov <dmonakhov@openvz.org> writes:

> Yes... everybody know that it is bad to write from kernel thread, and it is
> madness to do it with O_DIRECT. But occasionly file with O_DIRECT flag
> may be passed to loop device via LOOP_SET_FD. So if file-system has't
> address_space ops, or simply hide it like GFS, it is possible to kill kernel
> via two lines program. In fact we can't effectively guard kernel space by
> deny O_DIRECT in loop's code, because user space can set it via
> fcntl(,F_SETFL,). Let's simply add sanity check mm related logic.	

Wouldn't it be better if loop simply dup()ed the file descriptor
and then checked the flag?  Presumably other fd flags could
do bad things inside loop too.

-Andi

