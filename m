Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbZFCPlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbZFCPlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757992AbZFCPl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:41:29 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:42727 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758290AbZFCPl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:41:27 -0400
Date: Wed, 3 Jun 2009 11:41:12 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Stephen Smalley <sds@tycho.nsa.gov>
cc: "Larry H." <research@subreption.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change
 ZERO_SIZE_PTR to point at unmapped space)
In-Reply-To: <1244041914.12272.64.camel@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0906031134410.13551@gentwo.org>
References: <20090530192829.GK6535@oblivion.subreption.com>  <alpine.LFD.2.01.0905301528540.3435@localhost.localdomain>  <20090530230022.GO6535@oblivion.subreption.com>  <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain>  <20090531022158.GA9033@oblivion.subreption.com>
  <alpine.DEB.1.10.0906021130410.23962@gentwo.org>  <20090602203405.GC6701@oblivion.subreption.com>  <alpine.DEB.1.10.0906031047390.15621@gentwo.org> <1244041914.12272.64.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009, Stephen Smalley wrote:

> > If one remaps page 0 then the kernel checks for NULL pointers of various
> > flavors are bypassed and this may be exploited in various creative ways
> > to transfer data from kernel space to user space.
> >
> > Fix this by not allowing the remapping of page 0. Return -EINVAL if
> > such a mapping is attempted.
>
> You can already prevent unauthorized processes from mapping low memory
> via the existing mmap_min_addr setting, configurable via
> SECURITY_DEFAULT_MMAP_MIN_ADDR or /proc/sys/vm/mmap_min_addr.  Then
> cap_file_mmap() or selinux_file_mmap() will apply a check when a process
> attempts to map memory below that address.

mmap_min_addr depends on CONFIG_SECURITY which establishes various
strangely complex "security models".

The system needs to be secure by default.


