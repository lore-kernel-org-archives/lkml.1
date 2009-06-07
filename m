Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbZFGGIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbZFGGIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 02:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbZFGGIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 02:08:23 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45640 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbZFGGIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 02:08:22 -0400
Subject: Re: [PATCH] integrity: fix IMA inode leak
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mimi Zohar <zohar@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>, James Morris <jmorris@namei.org>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.01.0906061416170.6847@localhost.localdomain>
References: <Pine.LNX.4.64.0906062109580.8365@sister.anvils>
	 <alpine.LFD.2.01.0906061416170.6847@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 02:08:21 -0400
Message-Id: <1244354901.3963.23.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-06 at 14:18 -0700, Linus Torvalds wrote:
> 
> On Sat, 6 Jun 2009, Hugh Dickins wrote:
> >
> > CONFIG_IMA=y inode activity leaks iint_cache and radix_tree_node objects
> > until the system runs out of memory.  Nowhere is calling ima_inode_free()
> > a.k.a. ima_iint_delete().  Fix that by calling it from destroy_inode().
> 
> Shouldn't we call it from "security_inode_free()" instead? And shouldn't 
> it be allocated in "security_inode_alloc()"? That sounds like the correct 
> nesting here, since the whole integrity thing is under the security 
> module.
> 
> Hmm?
> 
> 		Linus

Mandatory Access Control(MAC) modules (i.e. SELinux, smack, etc) and
integrity (i.e IMA) are two different aspects of security.  The LSM
hooks, which includes security_inode_free(), are used to implement MAC,
not integrity.

Mimi Zohar


