Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZKUTVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZKUTVD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 14:21:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbZKUTVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 14:21:02 -0500
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:33186 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754071AbZKUTVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 14:21:01 -0500
Message-ID: <4B083DA0.90100@internode.on.net>
Date: Sun, 22 Nov 2009 05:51:04 +1030
From: indexer <indexer@internode.on.net>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Regression in efi.c 2.6.32-rc7
References: <4B065C44.5000209@internode.on.net> <4B06CE9D.3030003@zytor.com>
In-Reply-To: <4B06CE9D.3030003@zytor.com>
Content-Type: multipart/mixed;
 boundary="------------040209020102060302090206"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040209020102060302090206
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Peter, Huang

I have finally bisected this again.

7bd867dfb4e0357e06a3211ab2bd0e714110def3 is the first bad commit
commit 7bd867dfb4e0357e06a3211ab2bd0e714110def3
Author: Feng Tang <feng.tang@intel.com>
Date:   Thu Sep 10 10:48:56 2009 +0800

    x86: Move get/set_wallclock to x86_platform_ops
   
    get/set_wallclock() have already a set of platform dependent
    implementations (default, EFI, paravirt). MRST will add another
    variant.
   
    Moving them to platform ops simplifies the existing code and minimizes
    the effort to integrate new variants.
   
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    LKML-Reference: <new-submission>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

:040000 040000 3354b278e2ab54d62e2e2550276074817383e575 
1e4c3569eb9982171e63be6bdf7354b5de9b3b6e M    arch

I have also attached the bisect log along with this. I hope this helps, 
and apologise for the issues before as im still new to git.

William

--------------040209020102060302090206
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="bisect-log"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="bisect-log"

Z2l0IGJpc2VjdCBzdGFydAojIGdvb2Q6IFs1OWEzNzU5ZDBmZThkOTY5ODg4Yzc0MWJiMzNm
NDk0NmU0ZDM3NTBkXSBMaW51eCAyLjYuMzAtcmM3CmdpdCBiaXNlY3QgZ29vZCA1OWEzNzU5
ZDBmZThkOTY5ODg4Yzc0MWJiMzNmNDk0NmU0ZDM3NTBkCiMgYmFkOiBbMTU2MTcxYzcxYTBk
YzRiY2UxMmI0NDA4YmIxNTkxZjhmZTMyZGMxYV0gTGludXggMi42LjMyLXJjNwpnaXQgYmlz
ZWN0IGJhZCAxNTYxNzFjNzFhMGRjNGJjZTEyYjQ0MDhiYjE1OTFmOGZlMzJkYzFhCiMgZ29v
ZDogWzg0ODZhMGY5NWM4NDRiMjdlY2M4NTVjZmVjODliN2UzNGY4MzFjYWRdIE1lcmdlIGdp
dDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9kYXZlbS9uZXQt
Mi42CmdpdCBiaXNlY3QgZ29vZCA4NDg2YTBmOTVjODQ0YjI3ZWNjODU1Y2ZlYzg5YjdlMzRm
ODMxY2FkCiMgZ29vZDogW2FiZjU5NDBkYWQ3OGRkZTk1ZWRkN2Y2YmE2ZTMyOWNkMTBhOTJh
NWNdIE1lcmdlIGJyYW5jaCAnZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdmFwaWVyL2JsYWNrZmluCmdpdCBiaXNlY3QgZ29v
ZCBhYmY1OTQwZGFkNzhkZGU5NWVkZDdmNmJhNmUzMjljZDEwYTkyYTVjCiMgYmFkOiBbYTdm
MDc2NWVkZmQ1M2FlZDA5Y2I3YjBlMTU4NjM2ODhiMzk0NDdkZV0gcHRyYWNlOiBfX3B0cmFj
ZV9kZXRhY2g6IGRvIF9fd2FrZV91cF9wYXJlbnQoKSBpZiB3ZSByZWFwIHRoZSB0cmFjZWUK
Z2l0IGJpc2VjdCBiYWQgYTdmMDc2NWVkZmQ1M2FlZDA5Y2I3YjBlMTU4NjM2ODhiMzk0NDdk
ZQojIGJhZDogW2M3MjBmNTY1NWRmMTU5YTYzMGZhMDI5MGEwYmQ2N2M5M2U5MmIwYmZdIE1l
cmdlIGJyYW5jaCAnZm9yX2xpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2Nt
L2xpbnV4L2tlcm5lbC9naXQvbWNoZWhhYi9saW51eC0yLjYKZ2l0IGJpc2VjdCBiYWQgYzcy
MGY1NjU1ZGYxNTlhNjMwZmEwMjkwYTBiZDY3YzkzZTkyYjBiZgojIGdvb2Q6IFs1MTViNjk2
YjI4MmY4NTZjM2FkMTY3OWNjZDY1ODEyMGZhYTM4N2QwXSBNZXJnZSBnaXQ6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbGV0aGFsL3NoLTIuNgpnaXQgYmlz
ZWN0IGdvb2QgNTE1YjY5NmIyODJmODU2YzNhZDE2NzljY2Q2NTgxMjBmYWEzODdkMAojIGJh
ZDogW2JlM2JkZmI2ZTAxZjNlNzJiODE0NzU4NjA2ZTg5ZDQ4MjllOWU4OGZdIFY0TC9EVkIg
KDEzMDA0KTogZ3NwY2EgLSBzdHYwNnh4OiBIYXJtb25pemUgdGhlIGRlYnVnIG1hY3JvcyB3
aGVuIHRyYWNpbmcgd3JpdGVzIGFuZCByZWFkcwpnaXQgYmlzZWN0IGJhZCBiZTNiZGZiNmUw
MWYzZTcyYjgxNDc1ODYwNmU4OWQ0ODI5ZTllODhmCiMgYmFkOiBbNjgwNzFhZGQ5MWIyMmZh
MzYxYjY1NzY1ZTgwMTA3YzQ0OTI3YjVmYl0gVjRML0RWQiAoMTI4NDcpOiBjeDI1ODIxOiBB
ZGQgUkVBRE1FIHdpdGggdG9kbyBsaXN0CmdpdCBiaXNlY3QgYmFkIDY4MDcxYWRkOTFiMjJm
YTM2MWI2NTc2NWU4MDEwN2M0NDkyN2I1ZmIKIyBnb29kOiBbMzUzMGMxODg2MjkxZGYwNjFl
Mzk3MmM1NTU5MDc3N2VmMWNiNjdmOF0gTWVyZ2UgYnJhbmNoICdmb3JfbGludXMnIG9mIGdp
dDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90eXRzby9leHQ0
CmdpdCBiaXNlY3QgZ29vZCAzNTMwYzE4ODYyOTFkZjA2MWUzOTcyYzU1NTkwNzc3ZWYxY2I2
N2Y4CiMgZ29vZDogWzQ3YTNkNWRhNzBmNDExYmMwNDRlY2QzYzA1OTNiMTU4YjA5ZDBlZmFd
IHg4NjogQWRkIGVhcmx5IHBsYXRmb3JtIGRldGVjdGlvbgpnaXQgYmlzZWN0IGdvb2QgNDdh
M2Q1ZGE3MGY0MTFiYzA0NGVjZDNjMDU5M2IxNThiMDlkMGVmYQojIGJhZDogWzIwNjMxM2Ri
ODM2NDEwMjJjNWVlMjEzYWM1ZjYxOTk3M2E5YjQyN2JdIFY0TC9EVkIgKDEyNzQwKTogZW0y
OHh4OiBiZXR0ZXIgZGVzY3JpYmUgdmluY3RybCByZWdpc3RlcnMKZ2l0IGJpc2VjdCBiYWQg
MjA2MzEzZGI4MzY0MTAyMmM1ZWUyMTNhYzVmNjE5OTczYTliNDI3YgojIGJhZDogWzc4ZjI4
YjdjNTU1MzU5YzY3YzJhMGQyM2Y3NDM2ZTkxNTMyOTQyMWVdIE1lcmdlIGJyYW5jaCAneDg2
LXBsYXRmb3JtLWZvci1saW51cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9s
aW51eC9rZXJuZWwvZ2l0L3RpcC9saW51eC0yLjYtdGlwCmdpdCBiaXNlY3QgYmFkIDc4ZjI4
YjdjNTU1MzU5YzY3YzJhMGQyM2Y3NDM2ZTkxNTMyOTQyMWUKIyBnb29kOiBbNTRlMjYwM2Yx
YTg1Yjk3MjVhYTEzNTE4ZDY5MTQ4YjZlNzA2MWFhOV0geDg2OiBwbGF0Zm9ybTogRml4IHNl
Y3Rpb24gYW5ub3RhdGlvbnMKZ2l0IGJpc2VjdCBnb29kIDU0ZTI2MDNmMWE4NWI5NzI1YWEx
MzUxOGQ2OTE0OGI2ZTcwNjFhYTkKIyBnb29kOiBbOWM4OGIyNWJjZmRlNTFlY2NmMmNjYTEz
ZDkzM2EyOTQ4ZDBjYTRlYl0gZnJ2OiBjbGVhbiB1cCBsaW5rZXIgc2NyaXB0IHVzaW5nIG5l
dyBsaW5rZXIgc2NyaXB0IG1hY3Jvcy4KZ2l0IGJpc2VjdCBnb29kIDljODhiMjViY2ZkZTUx
ZWNjZjJjY2ExM2Q5MzNhMjk0OGQwY2E0ZWIKIyBiYWQ6IFs3YmQ4NjdkZmI0ZTAzNTdlMDZh
MzIxMWFiMmJkMGU3MTQxMTBkZWYzXSB4ODY6IE1vdmUgZ2V0L3NldF93YWxsY2xvY2sgdG8g
eDg2X3BsYXRmb3JtX29wcwpnaXQgYmlzZWN0IGJhZCA3YmQ4NjdkZmI0ZTAzNTdlMDZhMzIx
MWFiMmJkMGU3MTQxMTBkZWYzCg==
--------------040209020102060302090206--
