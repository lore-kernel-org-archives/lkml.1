Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbYKLQP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbYKLQP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYKLQMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:12:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45420 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871AbYKLQMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:12:08 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH =-v3 17/21] fanotify: add option to clear all fastpaths
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Date: Wed, 12 Nov 2008 11:11:56 -0500
Message-ID: <20081112161156.25434.62126.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify users because of a change in decision policy may need to clear all
fastpath entries.  This simply adds a new setsockopt call which will do
exactly that.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/fanotify.h   |    1 +
 net/fanotify/af_fanotify.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 14ad6f9..b7ab01f 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -89,6 +89,7 @@ struct fanotify_so_access {
 /* fanotify setsockopt optvals */
 #define FANOTIFY_SET_FASTPATH	1
 #define FANOTIFY_SEND_RESPONSE	2
+#define FANOTIFY_CLEAR_ALL_FASTPATH	3
 
 #ifdef __KERNEL__
 
diff --git a/net/fanotify/af_fanotify.c b/net/fanotify/af_fanotify.c
index eef7e2a..7c98a22 100644
--- a/net/fanotify/af_fanotify.c
+++ b/net/fanotify/af_fanotify.c
@@ -192,6 +192,9 @@ static int fan_setsockopt(struct socket *sock, int level, int optname, char __us
 			return ret;
 		ret = fanotify_process_access_response(group, data.access.cookie, data.access.response);
 		break;
+	case FANOTIFY_CLEAR_ALL_FASTPATH:
+		fanotify_fastpath_clear_group(group);
+		break;
 	default:
 		return -ENOPROTOOPT;
 	}

