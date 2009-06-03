Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbZFCTmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbZFCTmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbZFCTm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:42:29 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:43014 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751091AbZFCTm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:42:28 -0400
Date: Wed, 3 Jun 2009 15:42:13 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Eric Paris <eparis@parisplace.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Larry H." <research@subreption.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change 
 ZERO_SIZE_PTR to point at unmapped space)
In-Reply-To: <7e0fb38c0906031214lf4a2ed2x688da299e8cb1034@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0906031537110.20254@gentwo.org>
References: <20090530230022.GO6535@oblivion.subreption.com>  <alpine.DEB.1.10.0906031047390.15621@gentwo.org>  <20090603182949.5328d411@lxorguk.ukuu.org.uk>  <alpine.LFD.2.01.0906031032390.4880@localhost.localdomain>  <20090603180037.GB18561@oblivion.subreption.com>
  <alpine.LFD.2.01.0906031109150.4880@localhost.localdomain>  <20090603183939.GC18561@oblivion.subreption.com>  <alpine.LFD.2.01.0906031142390.4880@localhost.localdomain>  <alpine.LFD.2.01.0906031145460.4880@localhost.localdomain>  <alpine.DEB.1.10.0906031458250.9269@gentwo.org>
 <7e0fb38c0906031214lf4a2ed2x688da299e8cb1034@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009, Eric Paris wrote:

> NAK  with SELinux on you now need both the SELinux mmap_zero
> permission and the CAP_SYS_RAWIO permission.  Previously you only
> needed one or the other, depending on which was the predominant
> LSM.....

CAP_SYS_RAWIO is checked so you only need to check for mmap_zero in
SELinux.

> Even if you want to argue that I have to take CAP_SYS_RAWIO in the
> SELinux case what about all the other places?  do_mremap?  do_brk?
> expand_downwards?

brk(0) would free up all the code? The others could be added.


