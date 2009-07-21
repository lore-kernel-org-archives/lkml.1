Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbZGUGFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbZGUGFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 02:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbZGUGFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 02:05:14 -0400
Received: from mail-px0-f193.google.com ([209.85.216.193]:53871 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976AbZGUGEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 02:04:33 -0400
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net,
       Abhishek Kulkarni <adkulkar@umail.iu.edu>
Subject: [PATCH] 9p: minor comment fixes
Date: Tue, 21 Jul 2009 00:03:54 -0600
Message-Id: <1248156236-3005-5-git-send-email-adkulkar@umail.iu.edu>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1248156236-3005-1-git-send-email-adkulkar@umail.iu.edu>
References: <1248156236-3005-1-git-send-email-adkulkar@umail.iu.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the comments -- mostly the improper and/or missing descriptions
of function parameters.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
---
:100644 100644 5fda0a0... e221b14... M	fs/9p/vfs_inode.c
:100644 100644 787ccdd... 7bbd2d5... M	net/9p/client.c
:100644 100644 8c2588e... 8d934dd... M	net/9p/trans_fd.c
:100644 100644 ac49900... 65cb29d... M	net/9p/trans_rdma.c
:100644 100644 a49484e... 9bf0b73... M	net/9p/trans_virtio.c
 fs/9p/vfs_inode.c     |    3 +--
 net/9p/client.c       |   14 +++++++-------
 net/9p/trans_fd.c     |    8 ++++----
 net/9p/trans_rdma.c   |    9 +++++----
 net/9p/trans_virtio.c |   11 ++++-------
 5 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 5fda0a0..e221b14 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -171,7 +171,6 @@ int v9fs_uflags2omode(int uflags, int extended)
 
 /**
  * v9fs_blank_wstat - helper function to setup a 9P stat structure
- * @v9ses: 9P session info (for determining extended mode)
  * @wstat: structure to initialize
  *
  */
@@ -398,9 +397,9 @@ v9fs_open_created(struct inode *inode, struct file *file)
  * @v9ses: session information
  * @dir: directory that dentry is being created in
  * @dentry:  dentry that is being created
+ * @extension: 9p2000.u extension string to support devices, etc.
  * @perm: create permissions
  * @mode: open mode
- * @extension: 9p2000.u extension string to support devices, etc.
  *
  */
 static struct p9_fid *
diff --git a/net/9p/client.c b/net/9p/client.c
index 787ccdd..7bbd2d5 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -60,9 +60,9 @@ static struct p9_req_t *
 p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...);
 
 /**
- * v9fs_parse_options - parse mount options into session structure
- * @options: options string passed from mount
- * @v9ses: existing v9fs session information
+ * parse_options - parse mount options into client structure
+ * @opts: options string passed from mount
+ * @clnt: existing v9fs client information
  *
  * Return 0 upon success, -ERRNO upon failure
  */
@@ -232,7 +232,7 @@ EXPORT_SYMBOL(p9_tag_lookup);
 
 /**
  * p9_tag_init - setup tags structure and contents
- * @tags: tags structure from the client struct
+ * @c:  v9fs client struct
  *
  * This initializes the tags structure for each client instance.
  *
@@ -258,7 +258,7 @@ error:
 
 /**
  * p9_tag_cleanup - cleans up tags structure and reclaims resources
- * @tags: tags structure from the client struct
+ * @c:  v9fs client struct
  *
  * This frees resources associated with the tags structure
  *
@@ -430,8 +430,8 @@ static int p9_check_errors(struct p9_client *c, struct p9_req_t *req)
 
 /**
  * p9_client_flush - flush (cancel) a request
- * c: client state
- * req: request to cancel
+ * @c: client state
+ * @oldreq: request to cancel
  *
  * This sents a flush for a particular requests and links
  * the flush request to the original request.  The current
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 8c2588e..8d934dd 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -119,8 +119,8 @@ struct p9_poll_wait {
  * @wpos: write position for current frame
  * @wsize: amount of data to write for current frame
  * @wbuf: current write buffer
+ * @poll_pending_link: pending links to be polled per conn
  * @poll_wait: array of wait_q's for various worker threads
- * @poll_waddr: ????
  * @pt: poll state
  * @rq: current read work
  * @wq: current write work
@@ -700,9 +700,9 @@ static int p9_fd_cancel(struct p9_client *client, struct p9_req_t *req)
 }
 
 /**
- * parse_options - parse mount options into session structure
- * @options: options string passed from mount
- * @opts: transport-specific structure to parse options into
+ * parse_opts - parse mount options into p9_fd_opts structure
+ * @params: options string passed from mount
+ * @opts: fd transport-specific structure to parse options into
  *
  * Returns 0 upon success, -ERRNO upon failure
  */
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index ac49900..65cb29d 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -67,14 +67,15 @@
  * @pd: Protection Domain pointer
  * @qp: Queue Pair pointer
  * @cq: Completion Queue pointer
+ * @dm_mr: DMA Memory Region pointer
  * @lkey: The local access only memory region key
  * @timeout: Number of uSecs to wait for connection management events
  * @sq_depth: The depth of the Send Queue
  * @sq_sem: Semaphore for the SQ
  * @rq_depth: The depth of the Receive Queue.
+ * @rq_count: Count of requests in the Receive Queue.
  * @addr: The remote peer's address
  * @req_lock: Protects the active request list
- * @send_wait: Wait list when the SQ fills up
  * @cm_done: Completion event for connection management tracking
  */
 struct p9_trans_rdma {
@@ -154,9 +155,9 @@ static match_table_t tokens = {
 };
 
 /**
- * parse_options - parse mount options into session structure
- * @options: options string passed from mount
- * @opts: transport-specific structure to parse options into
+ * parse_opts - parse mount options into rdma options structure
+ * @params: options string passed from mount
+ * @opts: rdma transport-specific structure to parse options into
  *
  * Returns 0 upon success, -ERRNO upon failure
  */
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index a49484e..9bf0b73 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -57,11 +57,9 @@ static int chan_index;
  * @initialized: whether the channel is initialized
  * @inuse: whether the channel is in use
  * @lock: protects multiple elements within this structure
+ * @client: client instance
  * @vdev: virtio dev associated with this channel
  * @vq: virtio queue associated with this channel
- * @tagpool: accounting for tag ids (and request slots)
- * @reqs: array of request slots
- * @max_tag: current number of request_slots allocated
  * @sg: scatter gather list which is used to pack a request (protected?)
  *
  * We keep all per-channel information in a structure.
@@ -92,7 +90,7 @@ static unsigned int rest_of_page(void *data)
 
 /**
  * p9_virtio_close - reclaim resources of a channel
- * @trans: transport state
+ * @client: client instance
  *
  * This reclaims a channel by freeing its resources and
  * reseting its inuse flag.
@@ -181,9 +179,8 @@ static int p9_virtio_cancel(struct p9_client *client, struct p9_req_t *req)
 
 /**
  * p9_virtio_request - issue a request
- * @t: transport state
- * @tc: &p9_fcall request to transmit
- * @rc: &p9_fcall to put reponse into
+ * @client: client instance issuing the request
+ * @req: request to be issued
  *
  */
 
-- 
1.6.0.4

