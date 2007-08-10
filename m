Return-Path: <linux-kernel-owner+w=401wt.eu-S937542AbXHJP43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937542AbXHJP43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 11:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762545AbXHJP4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 11:56:20 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47356 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbXHJP4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 11:56:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@sw.ru>, axboe@kernel.dk
Subject: Re: [PATCH 08/10] sysctl: Remove broken cdrom binary sysctls
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
	<20070810143342.173d2637@the-village.bc.nu>
Date: Fri, 10 Aug 2007 09:55:09 -0600
In-Reply-To: <20070810143342.173d2637@the-village.bc.nu> (Alan Cox's message
	of "Fri, 10 Aug 2007 14:33:42 +0100")
Message-ID: <m17io3z8o2.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> On Thu, 09 Aug 2007 19:01:14 -0600
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> 
>> The binary interface for the cdrom sysctls can't possilby work.
>> So remove the binary sysctls and update the test for finding
>> out which sysctl table entry we are dealy with to use the procname
>> and not the ctl_name (which I am removing).
>
> NAK
>
> I've no problem with the basic idea of removing the names from user
> space, but you've just demonstrated with the patch below that it causes
> some quite revolting changes for the bad in code which previously was
> nicely done switch statements and is now a nest of string compares and
> inline code.
>
> There are very good reasons to have a cookie in the sysctl entry for
> internal use and which is private to the subsystem using the sysctl (ie
> not for sysctl() use and not neccessarily unique).

Sure.  We currently have 3 fields for that: data, extra1, and extra2.
You need to cast them to get an integer values but their definition
especially extra1 and extra2 are left up to the caller.

In that code we could just do a test on valp (i.e. data in struct
ctl_table).

I just wanted something stupid and simple, so the -mm tree would not
be full of broken sysctls.

At least to my eyes the code doesn't look much worse.  But if you
want to do something better feel free.

Eric


