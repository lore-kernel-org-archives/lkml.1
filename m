Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbZK0Nc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbZK0Nc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZK0Nc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:32:26 -0500
Received: from smurf.noris.de ([192.109.102.42]:31994 "EHLO
	smurf.intern.smurf.noris.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751859AbZK0NcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:32:17 -0500
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Nov 2009 08:32:16 EST
Subject: Time nonlinearity (gettimeofday vs. mtime)
From: Matthias Urlichs <matthias@urlichs.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: {M:U} IT Design
Date: Fri, 27 Nov 2009 14:31:18 +0100
Message-ID: <1259328678.27675.539.camel@kiste>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Smurf-Spam-Score: -2.6 (--)
X-Smurf-Whitelist: +relay_from_hosts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lately I've seen this ugliness:

13:39:06.000313 clock_gettime(CLOCK_REALTIME, {1259325546, 341196}) = 0 <0.000010>
13:39:06.000685 mkdir("/var/tmp/CP_FileTest_TempFolder_d0AOiP/tempFolder1", 0777) = 0 <0.000043>
13:39:06.000973 stat64("/var/tmp/CP_FileTest_TempFolder_d0AOiP/tempFolder1", {st_dev=makedev(252, 2), st_ino=1919104, st_mode=S_IFDIR|0755, st_nlink=2, st_uid=501, st_gid=501, st_blksize=4096, st_blocks=8, st_size=4096, st_atime=2009/11/27-13:39:05, st_mtime=2009/11/27-13:39:05, st_ctime=2009/11/27-13:39:05}) = 0 <0.000015>

This strace says that st.st_mtime is smaller than time.tv_sec even though the time was acquired earlier.
Apparently, the problem is that ext3 uses a cached time value for performance.

Question: Is there a reason that the cached time is not updated every time somebody calls gettimeofday() or clock_gettime()?
Or did just that nobody notice this problem yet?




