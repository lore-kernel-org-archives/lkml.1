Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbZFCTvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbZFCTvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbZFCTvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:51:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:23428 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbZFCTvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:51:15 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0906031537110.20254@gentwo.org>
References: <20090530230022.GO6535@oblivion.subreption.com>
	 <alpine.LFD.2.01.0906031032390.4880@localhost.localdomain>
	 <20090603180037.GB18561@oblivion.subreption.com>
	 <alpine.LFD.2.01.0906031109150.4880@localhost.localdomain>
	 <20090603183939.GC18561@oblivion.subreption.com>
	 <alpine.LFD.2.01.0906031142390.4880@localhost.localdomain>
	 <alpine.LFD.2.01.0906031145460.4880@localhost.localdomain>
	 <alpine.DEB.1.10.0906031458250.9269@gentwo.org>
	 <7e0fb38c0906031214lf4a2ed2x688da299e8cb1034@mail.gmail.com>
	 <alpine.DEB.1.10.0906031537110.20254@gentwo.org>
Date: Wed, 3 Jun 2009 15:51:16 -0400
Message-ID: <7e0fb38c0906031251h6844ea08y2dbfa09a7f46eb5f@mail.gmail.com>
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change 
	ZERO_SIZE_PTR to point at unmapped space)
From: Eric Paris <eparis@parisplace.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Larry H." <research@subreption.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 3, 2009 at 3:42 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Wed, 3 Jun 2009, Eric Paris wrote:
>
>> NAK  with SELinux on you now need both the SELinux mmap_zero
>> permission and the CAP_SYS_RAWIO permission.  Previously you only
>> needed one or the other, depending on which was the predominant
>> LSM.....
>
> CAP_SYS_RAWIO is checked so you only need to check for mmap_zero in
> SELinux.

You misunderstand.  As it stands today if you use SELinux you need
only the selinux mmap_zero permission.  If you use capabilities you
need CAP_SYS_RAWIO.

With your patch SELinux policy would now have to grant CAP_SYS_RAWIO
everywhere it grants mmap_zero.  This not not acceptable.  Take notice
that with SELinux enabled cap_file_mmap is never called.....


>> Even if you want to argue that I have to take CAP_SYS_RAWIO in the
>> SELinux case what about all the other places?  do_mremap?  do_brk?
>> expand_downwards?
>
> brk(0) would free up all the code? The others could be added.

The 'right'est fix is as Alan suggested, duplicate the code

from security/capability.c::cap_file_mmap()
to include/linux/security.h::securitry_file_mmap()

-Eric
