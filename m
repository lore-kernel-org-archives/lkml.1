Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbZCSOyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbZCSOyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 10:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbZCSOyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 10:54:11 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:55123 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbZCSOyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 10:54:10 -0400
From: hooanon05@yahoo.co.jp
To: David Woodhouse <David.Woodhouse@intel.com>,
       Al Viro <viro@zeniv.linux.org.uk>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Q: NFSD readdir in linux-2.6.28
Date: Thu, 19 Mar 2009 23:54:04 +0900
Message-ID: <8036.1237474444@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello David and Al,
I have a question about NFSD readdir.

By the commit 14f7dd632011bb89c035722edd6ea0d90ca6b078
"[PATCH] Copy XFS readdir hack into nfsd code", nfsd_buffered_filldir()
was introduced and nfs3svc_encode_entry_plus() (the 'func' parameter) is
not called from vfs_readdir().

In 2.6.27, when nfs3svc_encode_entry_plus() calls lookup_one_len(), the
i_mutex lock was acquired by vfs_readdir() and it was not a problem.

After the commit (above), nfsd_readdir/nfsd_buffered_readdir/vfs_readdir
calls nfsd_buffered_filldir(), and nfs3svc_encode_entry_plus() is called
later.
In this sequence, lookup_one_len() is called without i_mutex held.

Isn't it a problem?


J. R. Okajima
