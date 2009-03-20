Return-Path: <linux-kernel-owner+w=401wt.eu-S1764444AbZCTXkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764444AbZCTXkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762998AbZCTXY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:59 -0400
Received: from kroah.org ([198.145.64.141]:48854 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762833AbZCTXY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:58 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:29 2009
Message-Id: <20090320222929.211666354@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Anholt <eric@anholt.net>,
       Dave Airlie <airlied@linux.ie>
Subject: [patch 40/43] drm/i915: Dont double-unpin buffers if we take a signal in evict_everything().
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-don-t-double-unpin-buffers-if-we-take-a-signal-in-evict_everything.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Anholt <eric@anholt.net>

commit b117763627ef4d24086801dd5f74c9eb2f487790 upstream.

We haven't seen this in practice, but it was visible when looking at a bug
report from when i915_gem_evict_everything() was broken and would always
return error.

Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Dave Airlie <airlied@linux.ie>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_gem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2036,6 +2036,7 @@ i915_gem_execbuffer(struct drm_device *d
 		/* unpin all of our buffers */
 		for (i = 0; i < pinned; i++)
 			i915_gem_object_unpin(object_list[i]);
+		pinned = 0;
 
 		/* evict everyone we can from the aperture */
 		ret = i915_gem_evict_everything(dev);


