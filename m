Return-Path: <linux-kernel-owner+w=401wt.eu-S936698AbXHJN0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936698AbXHJN0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 09:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763696AbXHJN0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 09:26:41 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34005 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759019AbXHJN0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 09:26:40 -0400
Date: Fri, 10 Aug 2007 14:33:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@sw.ru>, axboe@kernel.dk
Subject: Re: [PATCH 08/10] sysctl: Remove broken cdrom binary sysctls
Message-ID: <20070810143342.173d2637@the-village.bc.nu>
In-Reply-To: <m1ir7o8ap1.fsf_-_@ebiederm.dsl.xmission.com>
References: <20070726164518.GB16937@localhost.sw.ru>
	<m13azbulhf.fsf@ebiederm.dsl.xmission.com>
	<20070727145235.GC6924@localhost.sw.ru>
	<20070806124530.GD6634@localhost.sw.ru>
	<m1tzr8a3ms.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps1wa3kf.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hcn8a2rq.fsf_-_@ebiederm.dsl.xmission.com>
	<m1d4xw9psl.fsf_-_@ebiederm.dsl.xmission.com>
	<m18x8k9ppv.fsf_-_@ebiederm.dsl.xmission.com>
	<m14pj89pmt.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm108axi.fsf_-_@ebiederm.dsl.xmission.com>
	<m1vebo8avf.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6mc8at5.fsf_-_@ebiederm.dsl.xmission.com>
	<m1myx08arh.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ir7o8ap1.fsf_-_@ebiederm.dsl.xmission.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Aug 2007 19:01:14 -0600
ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> The binary interface for the cdrom sysctls can't possilby work.
> So remove the binary sysctls and update the test for finding
> out which sysctl table entry we are dealy with to use the procname
> and not the ctl_name (which I am removing).

NAK

I've no problem with the basic idea of removing the names from user
space, but you've just demonstrated with the patch below that it causes
some quite revolting changes for the bad in code which previously was
nicely done switch statements and is now a nest of string compares and
inline code.

There are very good reasons to have a cookie in the sysctl entry for
internal use and which is private to the subsystem using the sysctl (ie
not for sysctl() use and not neccessarily unique).

