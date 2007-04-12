Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399AbXDLS7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbXDLS7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 14:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXDLS7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 14:59:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbXDLS7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 14:59:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <5c49b0ed0704121123x341d10afxfdf6930b4b26417b@mail.gmail.com> 
References: <5c49b0ed0704121123x341d10afxfdf6930b4b26417b@mail.gmail.com>  <20070412024938.27380.44677.patchbomb.py@localhost> <1273.1176375482@redhat.com> 
To: "Nate Diller" <nate.diller@gmail.com>
Cc: "Andrew Morton" <akpm@osdl.org>,
       "Alexander Viro" <viro@zeniv.linux.org.uk>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Mikulas Patocka" <mikulas@artax.karlin.mff.cuni.cz>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Dave Kleikamp" <shaggy@austin.ibm.com>,
       "Anton Altaparmakov" <aia21@cantab.net>,
       "Evgeniy Dushistov" <dushistov@mail.ru>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-dev@namesys.com
Subject: Re: [PATCH 3/17] afs: convert afs_dir_get_page to read_kmap_page 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Thu, 12 Apr 2007 19:57:23 +0100
Message-ID: <29898.1176404243@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nate Diller <nate.diller@gmail.com> wrote:

> Hmmm you're right.  Is your security work going into the next -mm?

I don't know.  Andrew hasn't said anything.  Andrew?  Are you waiting for it
to go through DaveM's networking tree?

> If so, I'll just re-base this cleanup patch on that ... at the very least I
> want to get rid of afs_dir_put_page().

That's reasonable.

> Also, did you consider passing the key pointer directly and modifying the
> readpage actor to simply cast the pointer back, like
> read_mapping_page(mapping, page, (struct file *)key)?  It seems like a waste
> to allocate a whole file struct on the stack just for the ->private field.

There's one small problem with that...  And that's filemap_nopage() (it passes
vma->vm_file to readpage() unconditionally).  Unless, of course, your patches
fix that too...

David
