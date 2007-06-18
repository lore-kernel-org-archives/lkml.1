Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbXFRE6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbXFRE6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 00:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756655AbXFRE5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 00:57:53 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48938 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602AbXFRE5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 00:57:52 -0400
Message-ID: <4676109F.8020202@us.ibm.com>
Date: Sun, 17 Jun 2007 21:57:03 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Mozilla Thunderbird 1.0.7 (X11/20050923)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: systemtap@sources.redhat.com
Subject: [PATCH] relay-file-read-start-pos-fix.patch
Content-Type: multipart/mixed;
 boundary="------------040108050708030707040205"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040108050708030707040205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


-- 
David Wilder
IBM Linux Technology Center
Beaverton, Oregon, USA 
dwilder@us.ibm.com
(503)578-3789


--------------040108050708030707040205
Content-Type: text/x-patch;
 name="relay-file-read-start-pos-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="relay-file-read-start-pos-fix.patch"

This patch fixes a bug in the relay read interface causing the number
of consumed bytes to be set incorrectly. 

Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
Signed-off-by: David Wilder <dwilder@us.ibm.com>

 kernel/relay.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index 4311101..e61156e 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -899,7 +899,10 @@ static size_t relay_file_read_start_pos(size_t read_pos,
 	size_t read_subbuf, padding, padding_start, padding_end;
 	size_t subbuf_size = buf->chan->subbuf_size;
 	size_t n_subbufs = buf->chan->n_subbufs;
+	size_t consumed = buf->subbufs_consumed % n_subbufs;
 
+	if (!read_pos)
+		read_pos = consumed * subbuf_size + buf->bytes_consumed;
 	read_subbuf = read_pos / subbuf_size;
 	padding = buf->padding[read_subbuf];
 	padding_start = (read_subbuf + 1) * subbuf_size - padding;

--------------040108050708030707040205--
