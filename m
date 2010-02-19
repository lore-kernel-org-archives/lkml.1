Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705Ab0BSRMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:12:24 -0500
Received: from kroah.org ([198.145.64.141]:57562 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746Ab0BSRAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:38 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:42 2010
Message-Id: <20100219163242.184796000@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jason Wang <jasowang@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [41/93] Export the symbol of getboottime and mmonotonic_to_bootbased
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jason Wang <jasowang@redhat.com>

commit c93d89f3dbf0202bf19c07960ca8602b48c2f9a0 upstream.

Export getboottime and monotonic_to_bootbased in order to let them
could be used by following patch.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/timekeeping.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -845,6 +845,7 @@ void getboottime(struct timespec *ts)
 
 	set_normalized_timespec(ts, -boottime.tv_sec, -boottime.tv_nsec);
 }
+EXPORT_SYMBOL_GPL(getboottime);
 
 /**
  * monotonic_to_bootbased - Convert the monotonic time to boot based.
@@ -854,6 +855,7 @@ void monotonic_to_bootbased(struct times
 {
 	*ts = timespec_add_safe(*ts, total_sleep_time);
 }
+EXPORT_SYMBOL_GPL(monotonic_to_bootbased);
 
 unsigned long get_seconds(void)
 {


