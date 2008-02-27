Return-Path: <linux-kernel-owner+w=401wt.eu-S1758566AbYB0XNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566AbYB0XNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760028AbYB0XJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:09:05 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:48462 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761578AbYB0XJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:09:04 -0500
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: RFC Labeled NFS Initial Code Review
Date: Wed, 27 Feb 2008 15:39:35 -0500
Message-Id: <1204144786-3502-1-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch set is the first submission to fs-devel and lkml for the purpose of
code review. To test the patch set you need patches to nfs-utils as well. Since
this is just a code review I haven't posted the patch to nfs-utils however if
you want to test the code feel free to e-mail me and I will send you the
necessary patch.

Out of all of the functionality we have prototyped I have narrowed it down to
these items which I believe is the solid base for initial kernel inclusion.
These patches provide the mechanism to allow the server to provide security
labels to the client and a method for the client to change labels on the server.
The next revision of this patch set will allow for the client's subject
(process) label to be transmitted with the access requests so the server can
also make access decisions against the acting local policy. This part of the
patch set will be made substantially cleaner by the credentials patches
proposed by David Howells.

Known Issues:

Eventually stronger notification of security label changes will be added. For
now this is accomplished by using NFS's normal cache invalidation (timeout).

When acting as root on a root_squashed export changing the label on a file
manages to set the label locally in the NFS inode but doesn't set it on the
exported file system. In this case the fault is the server is returning OK for
the setattr option instead of EPERM. This will be fixed in the next version.

