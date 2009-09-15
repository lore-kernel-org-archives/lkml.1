Return-Path: <linux-kernel-owner+w=401wt.eu-S1751305AbZIOE2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbZIOE2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 00:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbZIOE2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 00:28:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbZIOE2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 00:28:18 -0400
Message-Id: <200909150428.n8F4SIGt023997@int-mx08.intmail.prod.int.phx2.redhat.com>
Date: Tue, 15 Sep 2009 00:28:17 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: <linux-kernel@vger.kernel.org>
Subject: binfmt_misc takes precedence over binfmt_script in 2.6.30
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steps to Reproduce:

mount -t binfmt_misc none /proc/sys/fs/binfmt_misc
echo ':xyzzy:E::xyzzy::/usr/bin/stat:' > /proc/sys/fs/binfmt_misc/register
echo '#!/bin/cat' > /tmp/test.xyzzy
chmod +x /tmp/test.xyzzy
/tmp/test.xyzzy

Actual results:
The test prints the output of /usr/bin/stat /tmp/test.xyzzy

Expected results:
The test prints "#!/bin/cat".

This appears to have changed in the upstream git commit 74641f5 "alpha:
binfmt_aout fix". The commit message for that commit says "Fixed by changing
the registration order of the default binfmt handlers using list_add_tail() and
introducing insert_binfmt() function which places new handler on the top of the
binfmt list.  This might be generally useful for installing arch-specific
frontends for default handlers or just for overriding them."

It's not clear that the new behavior is worse or better, but it's a
regression and should at the very least be documented.  
