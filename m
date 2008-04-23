Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbYDWQjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbYDWQjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 12:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYDWQjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 12:39:11 -0400
Received: from vena.lwn.net ([206.168.112.25]:43041 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbYDWQjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 12:39:11 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Document SEQ_SKIP
cc: viro@parcelfarce.linux.theplanet.co.uk
From: Jonathan Corbet <corbet@lwn.net>
Date: Wed, 23 Apr 2008 10:39:10 -0600
Message-ID: <16841.1208968750@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that SEQ_SKIP went into the mainline; here's a little doc fix
to match.  I'll feed this up through my docs tree unless somebody else
wants it.

jon

--
    Document SEQ_SKIP
    
    2.6.26 adds a SEQ_SKIP return value for the seq_file show() function;
    update the documentation to match.
    
    Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/Documentation/filesystems/seq_file.txt b/Documentation/filesystems/seq_file.txt
index 7fb8e6d..0ab92c2 100644
--- a/Documentation/filesystems/seq_file.txt
+++ b/Documentation/filesystems/seq_file.txt
@@ -122,8 +122,7 @@ stop() is the place to free it.
 	}
 
 Finally, the show() function should format the object currently pointed to
-by the iterator for output. It should return zero, or an error code if
-something goes wrong. The example module's show() function is:
+by the iterator for output.  The example module's show() function is:
 
 	static int ct_seq_show(struct seq_file *s, void *v)
 	{
@@ -132,6 +131,12 @@ something goes wrong. The example module's show() function is:
 	        return 0;
 	}
 
+If all is well, the show() function should return zero.  A negative error
+code in the usual manner indicates that something went wrong; it will be
+passed back to user space.  This function can also return SEQ_SKIP, which
+causes the current item to be skipped; if the show() function has already
+generated output before returning SEQ_SKIP, that output will be dropped.
+
 We will look at seq_printf() in a moment. But first, the definition of the
 seq_file iterator is finished by creating a seq_operations structure with
 the four functions we have just defined:
