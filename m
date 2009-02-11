Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbZBKPVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbZBKPVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 10:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbZBKPVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 10:21:01 -0500
Received: from netasq.netasq.com ([213.30.137.178]:32976 "EHLO
	netasq.netasq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbZBKPVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:21:00 -0500
X-Greylist: delayed 1412 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Feb 2009 10:21:00 EST
Date: Wed, 11 Feb 2009 15:56:56 +0100
To: linux-kernel@vger.kernel.org
Subject: [PATCH] 4 bytes kernel memory disclosure in SO_BSDCOMPAT gsopt
From: =?utf-8?Q?Cl=C3=A9ment_LECIGNE?= <clement.lecigne@netasq.com>
Organization: Netasq
Content-Type: multipart/mixed; boundary=----------YtULBI1unCTq4IVq1ou6o5
MIME-Version: 1.0
Message-ID: <op.uo6zs6xiw20ydt@clem1.netasq.com>
User-Agent: Opera Mail/9.63 (FreeBSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------------YtULBI1unCTq4IVq1ou6o5
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit

Hello lkml,

In function sock_getsockopt() located in net/core/sock.c, optval v.val is  
not correctly initialized and directly returned in userland in case we  
have SO_BSDCOMPAT option set.

This dummy code should trigger the bug:

int main(void)
{
         unsigned char buf[4] = { 0, 0, 0, 0 };
         int len;
         int sock;
         sock = socket(33, 2, 2);
         getsockopt(sock, 1, SO_BSDCOMPAT, &buf, &len);
         printf("%x%x%x%x\n", buf[0], buf[1], buf[2], buf[3]);
         close(sock);
}

Here is a patch that fix this bug by initalizing v.val just after its  
declaration.

Bests,

-- 
Clément LECIGNE,
:%s/coin/& coin/g
------------YtULBI1unCTq4IVq1ou6o5
Content-Disposition: attachment; filename=sock.bsdcompat.patch
Content-Type: application/octet-stream; name=sock.bsdcompat.patch
Content-Transfer-Encoding: Base64

LS0tIGxpbnV4L25ldC9jb3JlL3NvY2suYyAgICAgICAgMjAwOC0xMS0yNiAxNDoz
NzoxNy4wMDAwMDAwMDAgLTA4MDAKKysrIGxpbnV4L25ldC9jb3JlL3NvY2suYyAg
ICAgICAgMjAwOC0xMS0yNiAxNDozNzo0NS4wMDAwMDAwMDAgLTA4MDAKQEAgLTY5
NSw2ICs2OTUsOCBAQAogICAgICAgIGlmIChsZW4gPCAwKQogICAgICAgICAgICAg
ICAgcmV0dXJuIC1FSU5WQUw7CiAKKyAgICAgICB2LnZhbCA9IDA7CisKICAgICAg
ICBzd2l0Y2gob3B0bmFtZSkgewogICAgICAgIGNhc2UgU09fREVCVUc6CiAgICAg
ICAgICAgICAgICB2LnZhbCA9IHNvY2tfZmxhZyhzaywgU09DS19EQkcpOwo=

------------YtULBI1unCTq4IVq1ou6o5--

