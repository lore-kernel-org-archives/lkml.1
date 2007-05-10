Return-Path: <linux-kernel-owner+w=401wt.eu-S1761653AbXEJWZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653AbXEJWZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758726AbXEJWZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:25:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758310AbXEJWZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:25:08 -0400
Message-ID: <46439BBA.2070705@redhat.com>
Date: Thu, 10 May 2007 15:24:58 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: getcpu after sched_setaffinity
Content-Type: multipart/mixed;
 boundary="------------030705060804040500020104"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030705060804040500020104
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

The attached test program fails on a dual core (and probably SMP) 
machine on x86-64.  Depending on where the thread starts, in one of the 
iterations the sched_setffinity() call succeeds but then sched_getcpu() 
fails to report the correct CPU.

In set_cpus_allowed migrate_task() is called if the new CPU set does not 
include the current CPU.  I hope that migrate_task() also works for 
p==current.

This leaves the x86-64 vgetcpu() implementation as the weak point.  Is 
the caching causing problems?  Should migrate_task() make sure the cache 
is reset?

You need a very recent glibc to compile (glibc-2.5.90-22 in rawhide). 
If this is not available replace the sched_getcpu() call.  But make sure 
you pass a pointer to a cache.

-- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖

--------------030705060804040500020104
Content-Type: text/plain;
 name="tst-getcpu.c"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="tst-getcpu.c"

I2luY2x1ZGUgPGVycm5vLmg+CiNpbmNsdWRlIDxzdGRpby5oPgojaW5jbHVkZSA8c2NoZWQu
aD4KCgppbnQKbWFpbiAodm9pZCkKewogIGNwdV9zZXRfdCBjczsKICBpZiAoc2NoZWRfZ2V0
YWZmaW5pdHkgKGdldHBpZCAoKSwgc2l6ZW9mIChjcyksICZjcykgIT0gMCkKICAgIHsKICAg
ICAgcHJpbnRmICgiZ2V0YWZmaW5pdHkgZmFpbGVkOiAlbVxuIik7CiAgICAgIHJldHVybiAx
OwogICAgfQoKICBpbnQgcmVzdWx0ID0gMDsKICBpbnQgY3B1ID0gMDsKICB3aGlsZSAoQ1BV
X0NPVU5UICgmY3MpICE9IDApCiAgICB7CiAgICAgIGlmIChDUFVfSVNTRVQgKGNwdSwgJmNz
KSkKCXsKCSAgY3B1X3NldF90IGNzMjsKCSAgQ1BVX1pFUk8gKCZjczIpOwoJICBDUFVfU0VU
IChjcHUsICZjczIpOwoJICBpZiAoc2NoZWRfc2V0YWZmaW5pdHkgKGdldHBpZCAoKSwgc2l6
ZW9mIChjczIpLCAmY3MyKSAhPSAwKQoJICAgIHsKCSAgICAgIHByaW50ZiAoInNldGFmZmlu
aXR5KCVkKSBmYWlsZWQ6ICVtXG4iLCBjcHUpOwoJICAgICAgcmVzdWx0ID0gMTsKCSAgICB9
CgkgIGVsc2UKCSAgICB7CgkgICAgICBpbnQgY3B1MiA9IHNjaGVkX2dldGNwdSAoKTsKCSAg
ICAgIGlmIChjcHUyID09IC0xICYmIGVycm5vID09IEVOT1NZUykKCQl7CgkJICBwdXRzICgi
Z2V0Y3B1IHN5c2NhbGwgbm90IGltcGxlbWVudGVkIik7CgkJICByZXR1cm4gMDsKCQl9Cgkg
ICAgICBpZiAoY3B1MiAhPSBjcHUpCgkJewoJCSAgcHJpbnRmICgiZ2V0Y3B1IHJlc3VsdHMg
JWQgbm90IHBvc3NpYmxlXG4iLCBjcHUyKTsKCQkgIHJlc3VsdCA9IDE7CgkJfQoJICAgIH0K
CSAgQ1BVX0NMUiAoY3B1LCAmY3MpOwoJfQogICAgICArK2NwdTsKICAgIH0KCiAgcmV0dXJu
IHJlc3VsdDsKfQo=
--------------030705060804040500020104--
