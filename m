Return-Path: <linux-kernel-owner+w=401wt.eu-S1760114AbZAPEFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114AbZAPEFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 23:05:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbZAPEEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 23:04:55 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:51463 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbZAPEEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 23:04:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=pynYiOlSdIBq9vCUBthuleOti+xrMtg4zzgm6UrMhq+cKzIOJR/1XAy7Wa+jULw6XA
         jqJ04cgHyALhfiMZQLZ02QcPUY5JCVm41iEvAj8yb4Nze2fvD4RQkjFrhdEHH706vFUN
         fpMOKkLuBWrgKZafhz9HoK7yZRwujIOzDm900=
Message-ID: <72dbd3150901152004m2e3d721bwf2cc633361f1fe40@mail.gmail.com>
Date: Thu, 15 Jan 2009 20:04:53 -0800
From: "David Rees" <drees76@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Disk IO Slowly Grinds to a (near) Halt
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a server running Fedora 9 server running kernel
2.6.27.9-73.fc9 where inevitably, any sort of IO activity slows down
significantly.

The machine is a basic Athlon 64 X2 5000+, 3GB RAM and 4 disks
(2x250GB IDE and 2x1TB SATA) running in two software RAID1 arrays.

One IDE drive is connected to the onboard (Nvidia MCP51 pata_amd), the
other connected to a Promise (PDC20268 pata_pdc2027x) controller.

Both SATA drivers are connected to the onboard Nvidia MCP51 sata_nv controller.

I suspect that the culprit has something to do with the fact that this
machine acts as a BackupPC server, and as such, has a filesystem with
over 7million inodes on it (about 175GB in use on that partition), but
that's just a hunch.

A simple test to confirm the issue is to drop the caches, and then do
a directory listing on an empty directory.  Doesn't matter which raid1
array it's on.  On the normally performing systems I tested this
typically took 0.15-0.45 seconds.  On this slow system, it takes over
a second for the same test to run when it's acting up.  After a fresh
reboot, it takes less than 0.2 seconds.

Any ideas? The only thing that seems to help is rebooting the server.
Let me know if there is any more information I can provide that would
be helpful.

-Dave
