Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYCKSU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYCKSU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 14:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYCKSUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 14:20:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752009AbYCKSUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 14:20:47 -0400
Date: Tue, 11 Mar 2008 11:19:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, apw@shadowen.org
Subject: Re: [Build Failure] 2.6.25-rc5-mm1 Build fails with allmodconfig
 probe_4drives undefined
Message-Id: <20080311111958.c0d3188d.akpm@linux-foundation.org>
In-Reply-To: <47D68126.40109@linux.vnet.ibm.com>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	<47D68126.40109@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 18:25:02 +0530
Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

>   MODPOST 2279 modules
> ERROR: "probe_4drives" [drivers/ide/ide-core.ko] undefined!

Caused by ide-mm-ide-add-ide-4drives-host-driver-take-3.patch.  Applying
that patch alone to current mainline causes the above error after i386
`make allmodconfig'.

Just exporting the symbol doesn't fix it, so something funny is going on.

probe_4drives should not be initialised to zero.

probe_4drives should not be declared extern in drivers/ide/ide.c - please
declare it in a header which is included by the definition site and by all
users.
