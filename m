Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138AbXLZXOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbXLZXOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 18:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbXLZXOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 18:14:04 -0500
Received: from smtp-dmz-237-backup.dmz.nerim.net ([195.5.254.237]:56895 "EHLO
	kellthuzad.dmz.nerim.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750947AbXLZXOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 18:14:03 -0500
Date: Thu, 27 Dec 2007 00:12:13 +0100
From: Andre Majorel <aym-xunil@teaser.fr>
To: linux-kernel@vger.kernel.org
Subject: atimes not updated over NFS
Message-ID: <20071226231213.GB9777@aym.net2.nerim.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After upgrading an NFS server from kernel 2.6.12 to 2.6.23, the
atime of files is not updated any more when clients read them :

  client$ ll -u --time-style +%Y-%m-%d_%H:%M:%S /nfsmnt/zz
  -rw-r--r-- 1 xxx xxx 0 2007-12-21_14:58:11 /nfsmnt/zz
  client$ md5sum /nfsmnt/zz
  d41d8cd98f00b204e9800998ecf8427e  /nfsmnt/zz
  client$ date +%Y-%m-%d_%H:%M:%S
  2007-12-21_15:00:28
  client$ ll -u --time-style +%Y-%m-%d_%H:%M:%S /nfsmnt/zz
  -rw-r--r-- 1 xxx xxx 0 2007-12-21_14:58:11 /nfsmnt/zz

Reading the file locally, i.e. on the NFS server, does update the
atime :

  server$ ll -u --time-style +%Y-%m-%d_%H:%M:%S /nfsmnt/zz
  -rw-r--r-- 1 xxx xxx 0 2007-12-21_14:58:11 /nfsmnt/zz
  serveur$ md5sum /nfsmnt/zz
  d41d8cd98f00b204e9800998ecf8427e  /nfsmnt/zz
  serveur$ date +%Y-%m-%d_%H:%M:%S
  2007-12-21_15:04:00
  serveur$ ll -u --time-style +%Y-%m-%d_%H:%M:%S /nfsmnt/zz
  -rw-r--r-- 1 xxx xxx 0 2007-12-21_15:03:57 /nfsmnt/zz

/nfsmnt is mounted with options :
- server : rw,noexec,nosuid,nodev,nodiratime
- client : rw,user=root,nosuid,nodev,nodiratime,intr,rsize=8192,wsize=8192

Any ideas ?

-- 
André Majorel <URL:http://www.teaser.fr/~amajorel/>
Do not use this account for regular correspondence.
See the URL above for contact information.
