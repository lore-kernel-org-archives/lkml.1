Return-Path: <linux-kernel-owner+w=401wt.eu-S1751923AbZIYTC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbZIYTC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 15:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbZIYTCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 15:02:24 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:51690 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbZIYTCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 15:02:24 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Fri, 25 Sep 2009 13:02:22 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] vfs: new O_NODE open flag
In-reply-to: <9988.1253899252@turing-police.cc.vt.edu>
To: Valdis.Kletnieks@vt.edu
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Andreas Gruenbacher <agruen@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <20090925190222.GX10562@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <E1Mqpfq-0003uZ-Pw@pomaz-ex.szeredi.hu>
 <200909250223.58664.agruen@suse.de> <E1Mr3jF-0005G4-Sf@pomaz-ex.szeredi.hu>
 <20090925123747.GA31228@gallifrey> <9988.1253899252@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 25, 2009  13:20 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 25 Sep 2009 13:37:47 BST, "Dr. David Alan Gilbert" said:
> 
> > Given an fd opened in this way is it possible to reopen it normally and
> > be guarenteed to get the same object?
> 
> It's not possible even without this flag. Consider:
> 
>         fd1 = open("/tmp/foo",flags);
>         rc = rename("/tmp/foo","/tmp/bar");
>         fd2 = open("/tmp/foo",flags);
> 
> Or were you asking if *absent that sort of tomfoolery* if it would work?

No, the point is that we HAVE an fd that points to the original "/tmp/foo"
opened with O_NODE, and now (after an ioctl, stat, etc) we decide it is
safe to open the file read and/or write without releasing the existing
fd.  The whole point is to AVOID this kind of tomfoolery.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

