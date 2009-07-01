Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbZGATaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbZGATaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 15:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbZGATaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 15:30:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704AbZGATaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 15:30:11 -0400
Date: Wed, 1 Jul 2009 12:29:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, roland@redhat.com,
       serue@us.ibm.com, dhowells@redhat.com, amwang@redhat.com,
       jmorris@namei.org, linux-fsdevel@vger.kernel.org
Subject: Re: [Patch 2/3] elf: clean up fill_note_info()
Message-Id: <20090701122955.da45e073.akpm@linux-foundation.org>
In-Reply-To: <20090701050850.6188.59496.sendpatchset@localhost.localdomain>
References: <20090701050840.6188.84560.sendpatchset@localhost.localdomain>
	<20090701050850.6188.59496.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009 01:06:36 -0400
Amerigo Wang <amwang@redhat.com> wrote:

> +#define	NUM_NOTES	6
>  	info->notes = kmalloc(NUM_NOTES * sizeof(struct memelfnote),
>  			      GFP_KERNEL);
> +#undef NUM_NOTES

That #define amounts to a really perverse code comment.

How about we do this?

--- a/fs/binfmt_elf.c~elf-clean-up-fill_note_info-fix
+++ a/fs/binfmt_elf.c
@@ -1719,10 +1719,8 @@ static int elf_note_info_init(struct elf
 	memset(info, 0, sizeof(*info));
 	INIT_LIST_HEAD(&info->thread_list);
 
-#define	NUM_NOTES	6
-	info->notes = kmalloc(NUM_NOTES * sizeof(struct memelfnote),
-			      GFP_KERNEL);
-#undef NUM_NOTES
+	/* Allocate space for six ELF notes */
+	info->notes = kmalloc(6 * sizeof(struct memelfnote), GFP_KERNEL);
 	if (!info->notes)
 		return 0;
 	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
_

