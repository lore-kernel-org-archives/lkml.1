Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbXLWA1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbXLWA1M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 19:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbXLWA06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 19:26:58 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34807 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753199AbXLWA05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 19:26:57 -0500
Date: Sat, 22 Dec 2007 16:25:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michael Halcrow <mhalcrow@us.ibm.com>, mike@halcrow.us,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] (UPDATED) ecryptfs: check for existing key_tfm at mount
 time
Message-Id: <20071222162516.df6fe557.akpm@linux-foundation.org>
In-Reply-To: <476D4C8D.9080602@redhat.com>
References: <476B4CB9.9070700@redhat.com>
	<20071221205618.d04bea09.akpm@linux-foundation.org>
	<476D4C8D.9080602@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Dec 2007 11:42:37 -0600 Eric Sandeen <sandeen@redhat.com> wrote:

> Andrew Morton wrote:
> 
> > It would all look a lot more solid if this locking was retained and both
> > ecryptfs_tfm_exists() and ecryptfs_add_new_key_tfm() were designed to be
> > called under key_tfm_list_mutex.
> 
> Hmm good point, sorry for missing that.  How's this look?

key_tfm_list_mutex gets used in fs/ecryptfs/main.c but it is static in
fs/ecryptfs/crypto.c

