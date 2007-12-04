Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbXLDVlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbXLDVlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbXLDVlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:41:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43263 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796AbXLDVlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:41:15 -0500
Date: Tue, 4 Dec 2007 13:35:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9483] circular locking dependency detected
Message-Id: <20071204133515.83b26277.akpm@linux-foundation.org>
In-Reply-To: <20071204212518.GA10020@elte.hu>
References: <20071130073446.GA7864@skywalker>
	<20071204212518.GA10020@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007 22:25:18 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > =======================================================
> > [ INFO: possible circular locking dependency detected ]
> > 2.6.24-rc3 #6
> > -------------------------------------------------------
> > bash/2294 is trying to acquire lock:
> > (&journal->j_list_lock){--..}, at: [<c01eee2f>] journal_try_to_free_buffers+0x76/0x10c
> > 
> > but task is already holding lock:
> > (inode_lock){--..}, at: [<c01864b6>] drop_pagecache+0x48/0xd8
> > 
> > which lock already depends on the new lock.
> 
> Andrew, drop_pagecache() is root-only and it has some known deadlock, 
> right?
> 

yup.   It takes inode_lock at too high a level so it can walk the per-sb inode
lists.
