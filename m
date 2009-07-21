Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbZGUPFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbZGUPFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbZGUPFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:05:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51656 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754035AbZGUPFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:05:13 -0400
Date: Tue, 21 Jul 2009 16:04:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, sds@tycho.nsa.gov,
       jmorris@namei.org, spender@grsecurity.net, dwalsh@redhat.com,
       cl@linux-foundation.org, arjan@infradead.org, kyle@mcmartin.ca,
       cpardy@redhat.com, arnd@arndb.de
Subject: Re: [PATCH 1/2] VM/SELinux: require CAP_SYS_RAWIO for all mmap_zero
 operations
Message-ID: <20090721160437.5bda68b4@lxorguk.ukuu.org.uk>
In-Reply-To: <20090721144157.14159.23439.stgit@paris.rdu.redhat.com>
References: <20090721144157.14159.23439.stgit@paris.rdu.redhat.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009 10:41:58 -0400
Eric Paris <eparis@redhat.com> wrote:

> Currently non-SELinux systems need CAP_SYS_RAWIO for an application to mmap
> the 0 page.  On SELinux systems they need a specific SELinux permission,
> but do not need CAP_SYS_RAWIO.  This has proved to be a poor decision by
> the SELinux team as, by default, SELinux users are logged in unconfined and
> thus a malicious non-root has nothing stopping them from mapping the 0 page
> of virtual memory.

So the poor decision is in fact that the SELinux users start as
unconfined rather than taking away a few things like the the min map
stuff which can then be given back to specific apps.

> On a non-SELinux system, a malicious non-root user is unable to do this, as
> they need CAP_SYS_RAWIO.
> 
> This patch checks CAP_SYS_RAWIO for all operations which attemt to map a
> page below mmap_min_addr.

So "wine" now needs to run with CAP_SYS_RAWIO or you turn all the
security off.

Am I missing something here, this "solution" sounds completely brain
dead ?

Alan
