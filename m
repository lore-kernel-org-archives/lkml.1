Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759091AbYLQMar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091AbYLQMar (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYLQM3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53732 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbYLQM3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:10 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/24] GFS2: sparse annotation of gl->gl_spin
Date: Wed, 17 Dec 2008 11:30:03 +0000
Message-Id: <1229513423-19105-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-4-git-send-email-swhiteho@redhat.com>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-3-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-4-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>

fs/gfs2/glock.c:308:5: warning: context problem in 'do_promote': '_spin_unlock' expected different context
fs/gfs2/glock.c:308:5:    context '*gl+28': wanted >= 1, got 0
fs/gfs2/glock.c:529:2: warning: context problem in 'do_xmote': '_spin_unlock' expected different context
fs/gfs2/glock.c:529:2:    context '*gl+28': wanted >= 1, got 0
fs/gfs2/glock.c:925:3: warning: context problem in 'add_to_queue': '_spin_unlock' expected different context
fs/gfs2/glock.c:925:3:    context '*gl+28': wanted >= 1, got 0

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index c962283..27cb9cc 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -293,6 +293,8 @@ static void gfs2_holder_wake(struct gfs2_holder *gh)
  */
 
 static int do_promote(struct gfs2_glock *gl)
+__releases(&gl->gl_spin)
+__acquires(&gl->gl_spin)
 {
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 	struct gfs2_holder *gh, *tmp;
@@ -511,6 +513,8 @@ static unsigned int gfs2_lm_lock(struct gfs2_sbd *sdp, void *lock,
  */
 
 static void do_xmote(struct gfs2_glock *gl, struct gfs2_holder *gh, unsigned int target)
+__releases(&gl->gl_spin)
+__acquires(&gl->gl_spin)
 {
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 	struct gfs2_sbd *sdp = gl->gl_sbd;
@@ -576,6 +580,8 @@ static inline struct gfs2_holder *find_first_holder(const struct gfs2_glock *gl)
  */
 
 static void run_queue(struct gfs2_glock *gl, const int nonblock)
+__releases(&gl->gl_spin)
+__acquires(&gl->gl_spin)
 {
 	struct gfs2_holder *gh = NULL;
 
@@ -877,6 +883,8 @@ void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...)
  */
 
 static inline void add_to_queue(struct gfs2_holder *gh)
+__releases(&gl->gl_spin)
+__acquires(&gl->gl_spin)
 {
 	struct gfs2_glock *gl = gh->gh_gl;
 	struct gfs2_sbd *sdp = gl->gl_sbd;
-- 
1.6.0.3

