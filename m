Return-Path: <linux-kernel-owner+w=401wt.eu-S1762173AbXGYDso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762173AbXGYDso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 23:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbXGYDsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 23:48:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:32019 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbXGYDsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 23:48:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=RGQn4pXyG8a8Vpw1JwvQpA0k6l2Kx84IXw7oPRxN4+dod02JOv6c8DlqyNrcMr8bKrLivyAtjCx1oJR35de8xw9proJZ/RZ2tL19YqG5cXiE02e6Qt+v0wclHqNAQ7bUzGeJldlA7bJQ5Xj/mBU9C51VVYuFCcMSfqeTYmgNjrw=
Message-ID: <91b13c310707242048lb54b071u5e7fc4272b142475@mail.gmail.com>
Date: Wed, 25 Jul 2007 11:48:35 +0800
From: "rae l" <crquan@gmail.com>
To: "Alexander Viro" <viro@zeniv.linux.org.uk>
Subject: [RFC] fs/super.c: Why alloc_super use a static variable default_op?
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Why alloc_super use a static variable default_op?
the static struct super_operations default_op is just all zeros, and
just referenced as the initial value of a new allocated super_block,
what does it for?

the filesystem dependent code such as ext2_fill_super would fill this
field eventually,
and after carefully checked, it seems no one filesystem would need a
all zero default_op,

as the command output in the kernel source tree:
$ grep -RInw s_op fs/
You could check all the use of s_op.

/**
 *	alloc_super	-	create new superblock
 *	@type:	filesystem type superblock should belong to
 *
 *	Allocates and initializes a new &struct super_block.  alloc_super()
 *	returns a pointer new superblock or %NULL if allocation had failed.
 */
static struct super_block *alloc_super(struct file_system_type *type)
{
	struct super_block *s = kzalloc(sizeof(struct super_block),  GFP_USER);

	static struct super_operations default_op;

	if (s) {
		...
		s->s_op = &default_op;
		s->s_time_gran = 1000000000;
	}
out:
	return s;
}


-- 
Denis Cheng
Linux Application Developer

"One of my most productive days was throwing away 1000 lines of code."
 - Ken Thompson.
