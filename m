Return-Path: <linux-kernel-owner+w=401wt.eu-S1760002AbYB1R31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002AbYB1R31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 12:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbYB1R3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 12:29:19 -0500
Received: from hpsmtp-eml15.kpnxchange.com ([213.75.38.115]:48624 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753534AbYB1R3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 12:29:19 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-nfs@vger.kernel.org
Subject: [regression] nfs4: 30 second delay during umount of remote fs on system shutdown
Date: Thu, 28 Feb 2008 18:29:15 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802281829.16343.elendil@planet.nl>
X-OriginalArrivalTime: 28 Feb 2008 17:29:17.0410 (UTC) FILETIME=[71F6A420:01C87A2F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.25-rc2 and -rc3 I noticed a pause of 30 seconds when my system 
(Debian unstable, x86_64) is being shutdown. The cause is the unmounting of 
an nfs4 remote file system.
The pause does not happen with 2.6.24. I'm unsure about 2.6.25-rc1 as I was 
concentrating on other issues when I was testing that.

I can reproduce the same pause on an active system by stopping portmap 
before doing an umount of the filesystem.

The shutdown sequence on my box includes:
K20nfs-common
[...]
S20sendsigs
[...]
S31umountnfs.sh
S32portmap

So it seems that things should be OK (S32portmap is after S31umountnfs.sh), 
but in fact portmap has already been killed during S20sendsigs!

I have verified that portmap is also not running during S31umountnfs.sh with 
2.6.24, so apparently there has been a change in the kernel that has made 
umount look for portmap and cause the 30 second delay if it is not running.

Is this a kernel regression?

Cheers,
FJP
