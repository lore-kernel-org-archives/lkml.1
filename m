Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205AbZI1KZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbZI1KZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 06:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZI1KZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 06:25:30 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52815 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbZI1KZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 06:25:29 -0400
To: Valdis.Kletnieks@vt.edu
CC: linux@treblig.org, miklos@szeredi.hu, agruen@suse.de,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <19645.1253913514@turing-police.cc.vt.edu>
	(Valdis.Kletnieks@vt.edu)
Subject: Re: [PATCH] vfs: new O_NODE open flag
References: <E1Mqpfq-0003uZ-Pw@pomaz-ex.szeredi.hu> <200909250223.58664.agruen@suse.de> <E1Mr3jF-0005G4-Sf@pomaz-ex.szeredi.hu> <20090925123747.GA31228@gallifrey> <9988.1253899252@turing-police.cc.vt.edu>
            <20090925183523.GA6065@gallifrey> <19645.1253913514@turing-police.cc.vt.edu>
Message-Id: <E1MsDQ6-0001cY-92@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 28 Sep 2009 12:25:26 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Sep 2009, Valdis.Kletnieks wrote:
> On Fri, 25 Sep 2009 19:35:23 BST, "Dr. David Alan Gilbert" said:
> 
> > I know it's not possible without this flag, my interest is whether
> > it would be possible WITH this flag to promote an fd opened with the
> > O_NODE to a normal fd, guaranteeing that it's still operating on the
> > same object.
> 
> Well, maybe the question is if we should treat "promote" differently than
> "re-open"?
> 
> (And now I'm wondering what happens if you dup() one of these beasts....)

dup() only duplicates _references_ to an open file, it does not create
a new file.  The same applies to fork().

BTW I just checked, and it is possible to re-open or promote an fd
opened with O_NODE like this:

	char tmp[64];

	fd = open(filename, O_NODE | O_NOACCESS);
	/* ... */
	sprintf(tmp, "/proc/self/fd/%i", fd);
	fd_rw = open(tmp, O_RDWR);

Now fd_rw is guaranteed to refer to the same inode as fd.

Thanks,
Miklos
