Return-Path: <linux-kernel-owner+w=401wt.eu-S1752351AbZI1PV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbZI1PV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 11:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbZI1PV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 11:21:56 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61167 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZI1PVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 11:21:55 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Mon, 28 Sep 2009 09:21:28 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] vfs: new O_NODE open flag
In-reply-to: <E1MsDQ6-0001cY-92@pomaz-ex.szeredi.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Valdis.Kletnieks@vt.edu, linux@treblig.org, agruen@suse.de,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <20090928152128.GA3384@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <E1Mqpfq-0003uZ-Pw@pomaz-ex.szeredi.hu>
 <200909250223.58664.agruen@suse.de> <E1Mr3jF-0005G4-Sf@pomaz-ex.szeredi.hu>
 <20090925123747.GA31228@gallifrey> <9988.1253899252@turing-police.cc.vt.edu>
 <20090925183523.GA6065@gallifrey> <19645.1253913514@turing-police.cc.vt.edu>
 <E1MsDQ6-0001cY-92@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 28, 2009  12:25 +0200, Miklos Szeredi wrote:
> BTW I just checked, and it is possible to re-open or promote an fd
> opened with O_NODE like this:
> 
> 	char tmp[64];
> 
> 	fd = open(filename, O_NODE | O_NOACCESS);
> 	/* ... */
> 	sprintf(tmp, "/proc/self/fd/%i", fd);
> 	fd_rw = open(tmp, O_RDWR);
> 
> Now fd_rw is guaranteed to refer to the same inode as fd.

It seems very unpleasant to require applications using O_NODE to
reopen files using /proc.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

