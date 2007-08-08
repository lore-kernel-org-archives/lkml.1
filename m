Return-Path: <linux-kernel-owner+w=401wt.eu-S1760234AbXHHOHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234AbXHHOHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764044AbXHHOH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:07:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:36336 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761961AbXHHOHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:07:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type;
        b=r2lV+K9JodZ0tS2ADPCgI6nPQmm9fwdpSWbXxVdSYhUv8xTCoh3iDBlOg857Ppsl4fhwxx2eYW8NKWGmGPQwKZENHmGCC5NpUhc6yDs/YkeOje6zKxELT4LNQM2pJcC4sq087FnPh8AWGC3AIUAihxTbKxfl6q533KDutnFx5eg=
Message-ID: <1e62d1370708080707s14573038m66ebc830daf39fd5@mail.gmail.com>
Date: Wed, 8 Aug 2007 19:07:24 +0500
From: "Fawad Lateef" <fawadlateef@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>
Subject: Porting setjmp/longjmp to mips64 kernel issue
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_155645_30641059.1186582044134"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_155645_30641059.1186582044134
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

I am trying to implement/port the functionality of "setjmp" and
"longjmp" provided by glibc in a kernel module for mips64 based
embedded system; running debian with modified smp kernel 2.6.16 on
2-cores.

I removed all the floating-point registers save and restore
functionality from setjmp/longjmp functions as they are not
used/accessable from kernel.

Now the issue is:

Kernel hangs at instruction "j $31" in __longjmp function whenever I
try to do longjmp; the value loaded in registers (in longjmp function
especially PC in $31) are the same as I got in setjmp so it should
jump to correct location but I think its jmping to some other place
and simply stuck there.

The prints from my module before the kernel hangs is:

# insmod jmptest.ko
JMP test module loaded. Starting tests...
1:
pj_setjmp: 14 ....
calling first
calling second
pj_longjmp: 21 ....
__longjmp: 64 .... pc = [c00000000009d11c]

Can someone tell me if there is something wrong in my
porting/implementation __or__ give some hints ? I am attaching the
code in tar.gz (I am doing cross-compilation with embedded tool chain
so please adjust paths in Makefile when compiling)

Thanks in Advance.

-- 
Fawad Lateef

------=_Part_155645_30641059.1186582044134
Content-Type: application/x-gzip; name=setjmp_mips64_kern.tar.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f53vyg8r
Content-Disposition: attachment; filename="setjmp_mips64_kern.tar.gz"

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
------=_Part_155645_30641059.1186582044134--
