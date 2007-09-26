Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbXIZPYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbXIZPYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbXIZPYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:24:11 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53680 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbXIZPYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:24:10 -0400
Date: Wed, 26 Sep 2007 17:24:08 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH 03/25] Unionfs: display informational messages only if
 debug is on 
In-Reply-To: <200709261401.l8QE1B3P025688@agora.fsl.cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0709261720330.7066@fbirervta.pbzchgretzou.qr>
References: <200709261401.l8QE1B3P025688@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 26 2007 10:01, Erez Zadok wrote:
>> 
>> On Sep 25 2007 23:09, Erez Zadok wrote:
>> >--- a/fs/unionfs/commonfops.c
>> >+++ b/fs/unionfs/commonfops.c
>> >@@ -394,8 +394,8 @@ int unionfs_file_revalidate(struct file *file, bool willwrite)
>> > 	if (willwrite && IS_WRITE_FLAG(file->f_flags) &&
>> > 	    !IS_WRITE_FLAG(unionfs_lower_file(file)->f_flags) &&
>> > 	    is_robranch(dentry)) {
>> >-		printk(KERN_DEBUG "unionfs: do delay copyup of \"%s\"\n",
>> >-		       dentry->d_name.name);
>> >+		dprintk(KERN_DEBUG "unionfs: do delay copyup of \"%s\"\n",
>> >+			dentry->d_name.name);
>> 
>> Don't we have pr_debug() for that?
>
>Jan, what's the policy on people writing their own debugging printk systems.

Generally, the rule is "don't (re)invent another debug system"

>I've looked at what other file systems do, and found out that it varies a lot:

Oh that's either old code or code that has not been reviewed properly.
Fact is that I have been made aware of pr_debug() "often enough"
on netfilter-devel, and it looks like a good idea.

>I wanted something simple to allow me to not printk something that's just
>for informational/debugging purposes, but w/o having to #ifdef the printk in
>question, or define a complex debugging-level printk system.

Surprise, pr_debug() is just that all nicely wrapped up.
Want debug? Do it like this.

#ifdef CONFIG_UNIONFS_DEBUG
#	define DEBUG 1
#endif

and pr_debug() works magic.

>Now, looking at pr_debug (in linux/kernel.h), and indeed some filesystems
>(e.g., affs and configfs) use it.  But pr_debug is only active when #define
>DEBUG is on (not CONFIG_DEBUG).  I didn't see a config option that enable
>DEBUG: is there one?

No I do not think so. But when you grep for dprintk, you should also
grep for DEBUG, to be fair :p

