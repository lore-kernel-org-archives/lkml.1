Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYJXSbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYJXSbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbYJXSbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:31:16 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:55367 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbYJXSbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:31:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=k7MraXRhDmuuFCpyC1St4ONxhjNBz7mEMppUq2YOs1Y1kSgvRXcfAcLqPD0li6Nr/y
         zxP5IeOp/ltIqOISS7GKjCLPlC2T7qZ7RixiC/dlZfFe5weRdwryDZQOA/56QBTFfYH9
         SBqJ5Fyno7niMbjawdfzlpTeohk66l0Nby54E=
Subject: [PATCH] gfs2: sparse annotation of gl->gl_spin
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 11:31:12 -0700
Message-Id: <1224873072.5966.7.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/gfs2/glock.c:308:5: warning: context problem in 'do_promote': '_spin_unlock' expected different context
fs/gfs2/glock.c:308:5:    context '*gl+28': wanted >= 1, got 0
fs/gfs2/glock.c:529:2: warning: context problem in 'do_xmote': '_spin_unlock' expected different context
fs/gfs2/glock.c:529:2:    context '*gl+28': wanted >= 1, got 0
fs/gfs2/glock.c:925:3: warning: context problem in 'add_to_queue': '_spin_unlock' expected different context
fs/gfs2/glock.c:925:3:    context '*gl+28': wanted >= 1, got 0

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/gfs2/glock.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

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
1.6.0.3.723.g757e



