Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbZAMP6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbZAMP6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 10:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756363AbZAMP5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 10:57:55 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:49508 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205AbZAMP5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 10:57:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=s3Jq/64Le7oWqAMww5uPaGxGVQl6HLUF7Bq+itkhhhKpKVV29N4ANnaDLGaras2pm5
         k2VlfKbMUNmBFRkXc/RdaN4gvZAkXPvuJasAM0+6sK7HXRNP00DOkTfkg6bwA7UxJXNH
         ndEbbCCuiWp8K7S57ng61bzVqmSd16mFIdHw0=
Message-ID: <337eb86f0901130757k7d31ec5p82d6405e69549fef@mail.gmail.com>
Date: Tue, 13 Jan 2009 23:57:52 +0800
From: zhp <zhpsub@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Is there a 'radix_tree_destroy()' interface in radix-tree?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all,

I am now writing a kernel module for Linux, and need to use the
radix-tree implementation in kernel. (include/linux/radix-tree.h &
lib/radix-tree.c). However, I do not find any interface for me to
destroy the tree, i.e. remove all non-root nodes in the tree, and free
all of my elements inserted in the tree before (of course, the free_fn
should be passed in by the user).

Is there such an interface for lib users? If not, who can tell me what
should I do to perform such a destroy task without dirty work? It is
almost impossible for me to "lookup an element  to check whether it's
in the tree, delete it if yes", because all possible keys are very
very large.

Also, I think it will be very useful for the kernel radix-tree module
if it provide such an interface:

    radix_tree_destroy(struct radix_tree_root *rtree,
				rtree_free_node_fn free_fn)

How about adding such an interface as a patch if I finally have to do
the dirty work?

Thanks.
zhp
