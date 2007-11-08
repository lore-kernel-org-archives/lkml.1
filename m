Return-Path: <linux-kernel-owner+w=401wt.eu-S1762142AbXKHVqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762142AbXKHVqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 16:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbXKHVqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 16:46:16 -0500
Received: from bravo667.server4you.de ([85.25.132.126]:36753 "EHLO
	mail.sitenet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbXKHVqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 16:46:15 -0500
X-Greylist: delayed 1577 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Nov 2007 16:46:15 EST
Message-ID: <47337D83.5040706@czajsoft.pl>
Date: Thu, 08 Nov 2007 22:20:03 +0100
From: Przemyslaw Wegrzyn <czajnik@czajsoft.pl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Buffer overflow in CIFS VFS.
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I was looking at CIFS VFS code recently, trying to solve other issue,
just to find something that looks like a buffer overflow  bug.
The problem is in SendReceive() function in transport.c - it memcpy's
message payload into a buffer passed via out_buf param. The function
assumes that all buffers are of size (CIFSMaxBufSize +
MAX_CIFS_HDR_SIZE) , unfortunately it is also called with smaller
(MAX_CIFS_SMALL_BUFFER_SIZE) buffers.

To check this finding I patched Samba server to send oversized logoffX
messages. With ~ 16kB messages the client running 2.6.23.1 crashed upon
unmounting.

I've done a quick fix, available here:
http://czajnick.sitenet.pl/cifs-buffer-overflow-fix.patch.gz

