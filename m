Return-Path: <linux-kernel-owner+w=401wt.eu-S1760783AbXIJUKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760783AbXIJUKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 16:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbXIJUKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 16:10:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44919 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925AbXIJUKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 16:10:13 -0400
Date: Mon, 10 Sep 2007 13:08:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nadia.Derbey@bull.net
Cc: linux-kernel@vger.kernel.org, matthltc@us.ibm.com
Subject: Re: [RFC][PATCH 1/6] Storing ipcs into IDRs
Message-Id: <20070910130857.de90d8c5.akpm@linux-foundation.org>
In-Reply-To: <20070831112613.552219000@bull.net>
References: <20070831112445.976429000@bull.net>
	<20070831112613.552219000@bull.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007 13:24:46 +0200 Nadia.Derbey@bull.net wrote:

> [PATCH 01/06]
> 
> 
> This patch introduces ipcs storage into IDRs. The main changes are:
>   . This ipc_ids structure is changed: the entries array is changed into a
>     root idr structure.
>   . The grow_ary() routine is removed: it is not needed anymore when adding
>     an ipc structure, since we are now using the IDR facility.
>   . The ipc_rmid() routine interface is changed:
>        . there is no need for this routine to return the pointer passed in as
>          argument: it is now declared as a void
>        . since the id is now part of the kern_ipc_perm structure, no need to
>          have it as an argument to the routine
> 
> 

This is a large patch, and I have neither the time nor competence to review
it :(

I hope that someone will find the time to do a detailed review-n-test of
this code, because the IPC code is pretty touchy and isn't well-maintained,
as I'm sure you have noticed.

Meanwhile I'll queue the patches up for a bit of compile-time and runtime
testing, thanks.


> ...
>
> +		msq = (struct msg_queue *) ipc_findkey(&msg_ids(ns), key);

As a separate cleanup: the code casts the ipc_findkey to some outer struct
in all cases.  It would be nicer to convert this to container_of().  It'll
generate the same code, but it actually represents what the code is doing
and perhaps means that the code will continue to work if the `struct
kern_ipc_perm' is not at the start of the containing struct.


