Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZFVIaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZFVIaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 04:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZFVIa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 04:30:27 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56409 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbZFVIa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 04:30:27 -0400
Date: Mon, 22 Jun 2009 09:30:27 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: =?ISO-8859-15?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alex Deucher <alexdeucher@gmail.com>, Andrew Lutomirski <luto@mit.edu>,
       dri-devel@lists.sf.net, Jerome Glisse <jglisse@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm: previous pull req + 1.
In-Reply-To: <4A3F3E3A.2030202@shipmail.org>
Message-ID: <alpine.DEB.2.00.0906220920080.23557@skynet.skynet.ie>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie> <4A3DABE1.50309@mit.edu> <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie> <alpine.LFD.2.01.0906210945170.3119@localhost.localdomain> <alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>
 <cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com> <alpine.LFD.2.01.0906211223190.3119@localhost.localdomain> <alpine.DEB.2.00.0906212336200.20307@skynet.skynet.ie> <4A3F3E3A.2030202@shipmail.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >   
> There is a ttm_fbdev_mmap() function in TTM that may help in this situation.
> As with the standard ttm mmap it's using fault() which means it's possible to
> move out the backing buffer object if you first reserve it and then call
> unmap_mapping_range() on the relevant fbdev address space to kill existing
> user-space mappings.

Yup I've looked at this from the fbdev pov, however I hit the same problem
with the fbcon writes happening pretty much whenever they wanted to.

It might be possible to move the fbcon around by updating screen_base, but 
you'd need to have some sort of lock around the read/write functions, I 
think locking on each individual read/write might be a lot of overhead.

Ideallly something analogous to the X server Prepare/Finish access hooks.

Dave.

