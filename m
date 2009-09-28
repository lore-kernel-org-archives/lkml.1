Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbZI1Pxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbZI1Pxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 11:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbZI1Pxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 11:53:52 -0400
Received: from mail2.shareable.org ([80.68.89.115]:53786 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbZI1Pxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 11:53:52 -0400
Date: Mon, 28 Sep 2009 16:53:53 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Andreas Dilger <adilger@sun.com>
Cc: Valdis.Kletnieks@vt.edu, "Dr. David Alan Gilbert" <linux@treblig.org>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Andreas Gruenbacher <agruen@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: new O_NODE open flag
Message-ID: <20090928155353.GA25375@shareable.org>
References: <E1Mqpfq-0003uZ-Pw@pomaz-ex.szeredi.hu> <200909250223.58664.agruen@suse.de> <E1Mr3jF-0005G4-Sf@pomaz-ex.szeredi.hu> <20090925123747.GA31228@gallifrey> <9988.1253899252@turing-police.cc.vt.edu> <20090925190222.GX10562@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090925190222.GX10562@webber.adilger.int>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger wrote:
> > It's not possible even without this flag. Consider:
> > 
> >         fd1 = open("/tmp/foo",flags);
> >         rc = rename("/tmp/foo","/tmp/bar");
> >         fd2 = open("/tmp/foo",flags);
> > 
> > Or were you asking if *absent that sort of tomfoolery* if it would work?
> 
> No, the point is that we HAVE an fd that points to the original "/tmp/foo"
> opened with O_NODE, and now (after an ioctl, stat, etc) we decide it is
> safe to open the file read and/or write without releasing the existing
> fd.  The whole point is to AVOID this kind of tomfoolery.

Make sense, and openat() seems like a good way to accomplish it.

-- Jamie
