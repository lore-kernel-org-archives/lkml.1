Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbZJBUNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbZJBUNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757677AbZJBUNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:13:21 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:62688 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757490AbZJBUNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 16:13:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=OD55gjZ6zzbqC9RaB6E46KWokbsyro7jArr1JeeQUhKYks7bj+OQOf+CW8jewMdqcv
         oRnfMBAIMW8CUPjutyFx02acrxIP8LgCxBbLw3Wu2Bf7nSUvBfYZS7b+IrNK3mbenFnI
         zyYcLuMrwSsGmx/B/3dS1j1Mz2GH+1Pyvulks=
Date: Sat, 3 Oct 2009 00:13:22 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] const: constify remaining pipe_buf_operations
Message-ID: <20091002201322.GB29905@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 kernel/relay.c       |    2 +-
 kernel/trace/trace.c |    4 ++--
 net/core/skbuff.c    |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1198,7 +1198,7 @@ static void relay_pipe_buf_release(struct pipe_inode_info *pipe,
 	relay_consume_bytes(rbuf, buf->private);
 }
 
-static struct pipe_buf_operations relay_pipe_buf_ops = {
+static const struct pipe_buf_operations relay_pipe_buf_ops = {
 	.can_merge = 0,
 	.map = generic_pipe_buf_map,
 	.unmap = generic_pipe_buf_unmap,
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3103,7 +3103,7 @@ static void tracing_spd_release_pipe(struct splice_pipe_desc *spd,
 	__free_page(spd->pages[idx]);
 }
 
-static struct pipe_buf_operations tracing_pipe_buf_ops = {
+static const struct pipe_buf_operations tracing_pipe_buf_ops = {
 	.can_merge		= 0,
 	.map			= generic_pipe_buf_map,
 	.unmap			= generic_pipe_buf_unmap,
@@ -3589,7 +3589,7 @@ static void buffer_pipe_buf_get(struct pipe_inode_info *pipe,
 }
 
 /* Pipe buffer operations for a buffer. */
-static struct pipe_buf_operations buffer_pipe_buf_ops = {
+static const struct pipe_buf_operations buffer_pipe_buf_ops = {
 	.can_merge		= 0,
 	.map			= generic_pipe_buf_map,
 	.unmap			= generic_pipe_buf_unmap,
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -93,7 +93,7 @@ static int sock_pipe_buf_steal(struct pipe_inode_info *pipe,
 
 
 /* Pipe buffer operations for a socket. */
-static struct pipe_buf_operations sock_pipe_buf_ops = {
+static const struct pipe_buf_operations sock_pipe_buf_ops = {
 	.can_merge = 0,
 	.map = generic_pipe_buf_map,
 	.unmap = generic_pipe_buf_unmap,
