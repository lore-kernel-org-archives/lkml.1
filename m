Return-Path: <linux-kernel-owner+w=401wt.eu-S932917AbZLETkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917AbZLETkt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 14:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932773AbZLETko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 14:40:44 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38220 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974AbZLETko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 14:40:44 -0500
To: Andy Lutomirski <luto@mit.edu>
CC: miklos@szeredi.hu, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <4B1A7159.3070101@mit.edu> (message from Andy Lutomirski on Sat,
	05 Dec 2009 09:42:33 -0500)
Subject: Re: [PATCH v3] vfs: new O_NODE open flag
References: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu>	<20091202191549.1dbffa2e@lxorguk.ukuu.org.uk>	<E1NFva6-0001AI-0J@pomaz-ex.szeredi.hu> <20091202204828.4fa0c108@lxorguk.ukuu.org.uk> <E1NG4WJ-00026r-GE@pomaz-ex.szeredi.hu> <4B1A7159.3070101@mit.edu>
Message-Id: <E1NH0Ub-0007oy-43@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 05 Dec 2009 20:40:33 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Dec 2009, Andy Lutomirski wrote:
> I don't know what that means.  Do you mean that if:
> 
> root creates /dev/foo with 0666 perms
> eviluser opens /dev/foo with O_NODE

More precisely, O_NODE | O_NOACCESS

> root chmods /dev/foo to 0000
> root unlinks /dev/foo
> 
> then eviluser can't open /proc/self/fd/whatever for O_RDRW

Yes.

Maybe alan was worried about the O_NODE | O_RDWR, etc. case?  That
simply doesn't make any sense for special files.

Current patch only allows O_NOACCESS for any file type, but other
access modes may make sense for regular files, directories, and maybe
even symlinks.

Thanks,
Miklos
