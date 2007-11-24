Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbXKXIaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbXKXIaM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 03:30:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbXKXI36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 03:29:58 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:56938 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbXKXI36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 03:29:58 -0500
Message-ID: <4747E0C6.5010900@cosmosbay.com>
Date: Sat, 24 Nov 2007 09:28:54 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv5 4/5] Allow setting O_NONBLOCK flag for new sockets
References: <200711210728.lAL7SoJO015052@devserv.devel.redhat.com> <4747D00D.1090603@cosmosbay.com> <4747D610.6040108@redhat.com>
In-Reply-To: <4747D610.6040108@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------060804030609060201010703"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 24 Nov 2007 09:29:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060804030609060201010703
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Ulrich Drepper a écrit :
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Eric Dumazet wrote:
>> 1) Can the fd passing with recvmsg() on AF_UNIX also gets O_CLOEXEC
>> support ?
> 
> Already there, see MSG_CMSG_CLOEXEC.

OK, but maybe for consistency, we might accept the two mechanisms.

The one added in 2.6.23, and the more general indirect() way.

(See attached untested patch for the general idea, you'll have to also add
#if INDSYSCALL(recvmsg)
   case INDSYSCALL(recvmsg):
#endif
)

>> 2) Why this O_NONBLOCK ability is needed for sockets ? Is it a security
>> issue, and if yes could you remind it to me ?
> 
> No security issue.  But look at any correct network program, all need to
> set the mode to non-blocking.  Adding this support to the syscall comes
> at almost no cost and it cuts the cost for every program down by one or
> two syscalls.
> 

OK, thank you.


--------------060804030609060201010703
Content-Type: text/plain;
 name="scm.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="scm.patch"

ZGlmZiAtLWdpdCBhL25ldC9jb3JlL3NjbS5jIGIvbmV0L2NvcmUvc2NtLmMKaW5kZXggMTAw
YmE2ZC4uMzhhMGI3NyAxMDA2NDQKLS0tIGEvbmV0L2NvcmUvc2NtLmMKKysrIGIvbmV0L2Nv
cmUvc2NtLmMKQEAgLTIzMCwxMSArMjMwLDEyIEBAIHZvaWQgc2NtX2RldGFjaF9mZHMoc3Ry
dWN0IG1zZ2hkciAqbXNnLCBzdHJ1Y3Qgc2NtX2Nvb2tpZSAqc2NtKQogCSAgICAgaSsrLCBj
bWZwdHIrKykKIAl7CiAJCWludCBuZXdfZmQ7CisJCWludCBmbGFncyA9IElORElSRUNUX1BB
UkFNKGZpbGVfZmxhZ3MsIGZsYWdzKSAmIE9fQ0xPRVhFQzsKIAkJZXJyID0gc2VjdXJpdHlf
ZmlsZV9yZWNlaXZlKGZwW2ldKTsKIAkJaWYgKGVycikKIAkJCWJyZWFrOwogCQllcnIgPSBn
ZXRfdW51c2VkX2ZkX2ZsYWdzKE1TR19DTVNHX0NMT0VYRUMgJiBtc2ctPm1zZ19mbGFncwot
CQkJCQkgID8gT19DTE9FWEVDIDogMCk7CisJCQkJCSAgPyBPX0NMT0VYRUMgOiBmbGFncyk7
CiAJCWlmIChlcnIgPCAwKQogCQkJYnJlYWs7CiAJCW5ld19mZCA9IGVycjsK
--------------060804030609060201010703--
