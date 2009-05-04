Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbZEDJ3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbZEDJ3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 05:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbZEDJ3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 05:29:24 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:42463 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbZEDJ3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 05:29:23 -0400
Message-ID: <49FEB572.4010909@msgid.tls.msk.ru>
Date: Mon, 04 May 2009 13:29:22 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: compat ioctl32 for /dev/snapshot?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any reason why 32-bit uswsusp &Friends does not work
on 64bits kernel?

For one, 32bits s2disk produces the following when trying to
suspend:

  ioctl32(s2disk:4134): Unknown cmd fd(4) cmd(400c330d){t:'3';sz:12} arg(ff853554) on /dev/snapshot
  ioctl32(s2disk:4134): Unknown cmd fd(4) cmd(4004330a){t:'3';sz:4} arg(00000805) on /dev/snapshot

this is coming from:

     error = ioctl(dev, SNAPSHOT_SET_SWAP_AREA, &swap);
     if (error && !offset)
             error = ioctl(dev, SNAPSHOT_SET_SWAP_FILE, blkdev);

but I guess (just guess!) that other SNAPSHOT_* operations will
also fail the same way.

Is there a reason why those are not in compat_ioctl?

Thanks.

/mjt
