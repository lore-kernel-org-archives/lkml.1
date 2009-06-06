Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbZFFVT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbZFFVT1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 17:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZFFVTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 17:19:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751058AbZFFVTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 17:19:19 -0400
Date: Sat, 6 Jun 2009 14:18:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
cc: Mimi Zohar <zohar@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       James Morris <jmorris@namei.org>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] integrity: fix IMA inode leak
In-Reply-To: <Pine.LNX.4.64.0906062109580.8365@sister.anvils>
Message-ID: <alpine.LFD.2.01.0906061416170.6847@localhost.localdomain>
References: <Pine.LNX.4.64.0906062109580.8365@sister.anvils>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Jun 2009, Hugh Dickins wrote:
>
> CONFIG_IMA=y inode activity leaks iint_cache and radix_tree_node objects
> until the system runs out of memory.  Nowhere is calling ima_inode_free()
> a.k.a. ima_iint_delete().  Fix that by calling it from destroy_inode().

Shouldn't we call it from "security_inode_free()" instead? And shouldn't 
it be allocated in "security_inode_alloc()"? That sounds like the correct 
nesting here, since the whole integrity thing is under the security 
module.

Hmm?

		Linus
