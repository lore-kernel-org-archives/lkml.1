Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbZBTANe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbZBTANe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 19:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbZBTANH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 19:13:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755949AbZBTANG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 19:13:06 -0500
Date: Thu, 19 Feb 2009 16:12:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: dwmw2@infradead.org, bernds_cb1@t-online.de, dhowells@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] NOMMU: Make it possible for RomFS to use MTD
 devices directly
Message-Id: <20090219161211.9b80c129.akpm@linux-foundation.org>
In-Reply-To: <20090212104010.26766.20813.stgit@warthog.procyon.org.uk>
References: <20090212104000.26766.11068.stgit@warthog.procyon.org.uk>
	<20090212104010.26766.20813.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Feb 2009 10:40:10 +0000
David Howells <dhowells@redhat.com> wrote:

> Change RomFS so that it can use MTD devices directly - without the intercession
> of the block layer - as well as using block devices.
> 
> This permits RomFS:
> 
>  (1) to use the MTD direct mapping facility available under NOMMU conditions if
>      the underlying device is directly accessible by the CPU (including XIP);
> 
>  (2) and thus to be used when the block layer is disabled.
> 
> RomFS can be configured with support just for MTD devices, just for Block
> devices or for both.  If RomFS is configured for both, then it will treat
> mtdblock device files as MTD backing stores, not block layer backing stores.

My x86_64 usualconfig just exploded with

fs/romfs/storage.c:18:2: error: #error no ROMFS backing store interface configured

http://userweb.kernel.org/~akpm/config-akpm2.txt
