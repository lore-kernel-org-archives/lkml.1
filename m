Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbZFCRg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbZFCRg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 13:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZFCRgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 13:36:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752823AbZFCRgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 13:36:51 -0400
Date: Wed, 3 Jun 2009 10:35:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Christoph Lameter <cl@linux-foundation.org>,
       "Larry H." <research@subreption.com>, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change
 ZERO_SIZE_PTR to point at unmapped space)
In-Reply-To: <20090603182949.5328d411@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.01.0906031032390.4880@localhost.localdomain>
References: <20090530192829.GK6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301528540.3435@localhost.localdomain> <20090530230022.GO6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain> <20090531022158.GA9033@oblivion.subreption.com>
 <alpine.DEB.1.10.0906021130410.23962@gentwo.org> <20090602203405.GC6701@oblivion.subreption.com> <alpine.DEB.1.10.0906031047390.15621@gentwo.org> <20090603182949.5328d411@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Jun 2009, Alan Cox wrote:
>
> One way you could approach this would be to write a security module for
> non SELINUX users - one that did one thing alone - decide whether the app
> being run was permitted to map the low 64K perhaps by checking the
> security label on the file.

Unnecessary. I really think that 99% of all people are perfectly fine with 
just the "mmap_min_addr" rule, and no more.

The rest could just use SElinux or set it to zero. It's not like allowing 
mmap's at NULL is a huge problem. Sure, it allows a certain kind of attack 
vector, but it's by no means an easy or common one - you need to already 
have gotten fairly good local access to take advantage of it.

		Linus
