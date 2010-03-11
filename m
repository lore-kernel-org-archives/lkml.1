Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab0CKTKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 14:10:30 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:43963 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab0CKTK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 14:10:29 -0500
Message-ID: <4B994022.6030703@msgid.tls.msk.ru>
Date: Thu, 11 Mar 2010 22:10:26 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-aio@kvack.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: aio: compat_ioctl issue?
References: <4B956E5B.9020302@msgid.tls.msk.ru>	<x497hpm8p69.fsf@segfault.boston.devel.redhat.com>	<4B957122.4060007@msgid.tls.msk.ru>	<x49mxyi78ob.fsf@segfault.boston.devel.redhat.com>	<4B957AF3.6040801@msgid.tls.msk.ru>	<4B957D20.4010904@msgid.tls.msk.ru> <x49wrxij11s.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49wrxij11s.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer wrote:
[]
> Yeah, whoops.  I built the libaio test harness using -m32 and this patch
> works for me.  Would you mind giving it a try?

It appears to work here so far.  I did not run massive i/o test suite
but it now passes basic multiple kernel unpacking in parallel tests
(before it didnt' even recognize the partition table).

So the patch - at least basically - works.

Except that we now have code duplication in kernel.  Look at
fs/compat.c:compat_do_readv_writev() - it does the same as
compat_rw_copy_check_uvector() plus a bit more.  I guess it
is a good idea to use compat_rw_copy_check_uvector() in
compat_do_readv_writev() to build the compat vectors...

Thank you for the patch and the fix!

/mjt
