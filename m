Return-Path: <linux-kernel-owner+w=401wt.eu-S932499AbYETN7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499AbYETN7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 09:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbYETN7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 09:59:17 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:37801 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852AbYETN7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 09:59:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=tifIm2FV7wn3mPq/MPvARM6ng5NQR7SlG5MXepDwejOKX8UZi+38hrzu5r3WPLoqkYXI0CX4AsCUGi/vbXx5JI168l+ZNPYyb4Zlb990/Z0R7ktHvZuDXmCUeXjIjdAKVBdhbNcy9T/yxpYF23jS7UQ7oyv6+4/B5VmlOIEsyTE=
Message-ID: <7b9198260805200659p6ed28403t9b0b0ea995f158d5@mail.gmail.com>
Date: Tue, 20 May 2008 14:59:14 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Jeff Dike" <jdike@addtoit.com>
Subject: Re: UML fails to locate address space
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080520135238.GB6990@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_808_25700784.1211291954948"
References: <7b9198260805200408k1d6b70a8xc7e4c24106e5020f@mail.gmail.com>
	 <20080520135238.GB6990@c2.user-mode-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_808_25700784.1211291954948
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/5/20 Jeff Dike <jdike@addtoit.com>:
> On Tue, May 20, 2008 at 12:08:24PM +0100, Tom Spink wrote:
>> I've just recently pulled the latest GIT and compiled UML, however,
>> when I run it a message appears saying "Locating the top of the
>> address space... Address 0x0 no good?" and the program exits.
>
> Can you strace it and send me the output?

Attached.  I guess the line of interest is:

mmap2(NULL, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = -1 EACCES (Permission
denied)

>
>> After some digging, it appears that page_ok is returning false when
>> checking 'bottom', in os_get_task_size
>> (arch/um/os-Linux/sys-i386/task_size.c:96).  After running through
>> GDB, it seems that in line 31 of that file is where the segfault
>> occurs:
>>
>> n = *address;
>>
>> i.e. when trying to read from the address space (at address zero).
>
> The segfaults are on purpose - it will trap SIGSEGV and longjmp out of
> the handler and mark the affected address as not-usable.

I gathered that much - I was just letting you know which test it was
that was failing.

>
>                  Jeff
>

Thanks!

-- 
Tom Spink

------=_Part_808_25700784.1211291954948
Content-Type: application/octet-stream; name=uml-strace
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fggjwu0x0
Content-Disposition: attachment; filename=uml-strace

ZXhlY3ZlKCJsaW51eC0yLjYvdm1saW51eCIsIFsibGludXgtMi42L3ZtbGludXgiLCAidWJkMD0u
L3Jvb3RmcyJdLCBbLyogMzMgdmFycyAqL10pID0gMApicmsoMCkgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgPSAweDgzNGQwMDAKYWNjZXNzKCIvZXRjL2xkLnNvLm5vaHdjYXAiLCBG
X09LKSAgICAgID0gLTEgRU5PRU5UIChObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5KQptbWFwMihO
VUxMLCA4MTkyLCBQUk9UX1JFQUR8UFJPVF9XUklURSwgTUFQX1BSSVZBVEV8TUFQX0FOT05ZTU9V
UywgLTEsIDApID0gMHhiN2Y5MzAwMAphY2Nlc3MoIi9ldGMvbGQuc28ucHJlbG9hZCIsIFJfT0sp
ICAgICAgPSAtMSBFTk9FTlQgKE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkpCm9wZW4oIi9saWIv
dGxzL2k2ODYvc3NlMi9jbW92L2xpYnV0aWwuc28uMSIsIE9fUkRPTkxZKSA9IC0xIEVOT0VOVCAo
Tm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeSkKc3RhdDY0KCIvbGliL3Rscy9pNjg2L3NzZTIvY21v
diIsIDB4YmZlNTc3YTApID0gLTEgRU5PRU5UIChObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5KQpv
cGVuKCIvbGliL3Rscy9pNjg2L3NzZTIvbGlidXRpbC5zby4xIiwgT19SRE9OTFkpID0gLTEgRU5P
RU5UIChObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5KQpzdGF0NjQoIi9saWIvdGxzL2k2ODYvc3Nl
MiIsIDB4YmZlNTc3YTApID0gLTEgRU5PRU5UIChObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5KQpv
cGVuKCIvbGliL3Rscy9pNjg2L2Ntb3YvbGlidXRpbC5zby4xIiwgT19SRE9OTFkpID0gMwpyZWFk
KDMsICJcMTc3RUxGXDFcMVwxXDBcMFwwXDBcMFwwXDBcMFwwXDNcMFwzXDBcMVwwXDBcMEBcblww
XDAwMCIuLi4sIDUxMikgPSA1MTIKZnN0YXQ2NCgzLCB7c3RfbW9kZT1TX0lGUkVHfDA2NDQsIHN0
X3NpemU9OTY5NiwgLi4ufSkgPSAwCm1tYXAyKE5VTEwsIDEyNDMyLCBQUk9UX1JFQUR8UFJPVF9F
WEVDLCBNQVBfUFJJVkFURXxNQVBfREVOWVdSSVRFLCAzLCAwKSA9IDB4YjdmOGYwMDAKbW1hcDIo
MHhiN2Y5MTAwMCwgODE5MiwgUFJPVF9SRUFEfFBST1RfV1JJVEUsIE1BUF9QUklWQVRFfE1BUF9G
SVhFRHxNQVBfREVOWVdSSVRFLCAzLCAweDEpID0gMHhiN2Y5MTAwMApjbG9zZSgzKSAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgPSAwCm9wZW4oIi9saWIvdGxzL2k2ODYvY21vdi9saWJj
LnNvLjYiLCBPX1JET05MWSkgPSAzCnJlYWQoMywgIlwxNzdFTEZcMVwxXDFcMFwwXDBcMFwwXDBc
MFwwXDBcM1wwXDNcMFwxXDBcMFwwXDI2MGVcMSIuLi4sIDUxMikgPSA1MTIKZnN0YXQ2NCgzLCB7
c3RfbW9kZT1TX0lGUkVHfDA3NTUsIHN0X3NpemU9MTM2NDM4OCwgLi4ufSkgPSAwCm1tYXAyKE5V
TEwsIDEzNjk3MTIsIFBST1RfUkVBRHxQUk9UX0VYRUMsIE1BUF9QUklWQVRFfE1BUF9ERU5ZV1JJ
VEUsIDMsIDApID0gMHhiN2U0MDAwMAptbWFwMigweGI3Zjg5MDAwLCAxMjI4OCwgUFJPVF9SRUFE
fFBST1RfV1JJVEUsIE1BUF9QUklWQVRFfE1BUF9GSVhFRHxNQVBfREVOWVdSSVRFLCAzLCAweDE0
OSkgPSAweGI3Zjg5MDAwCm1tYXAyKDB4YjdmOGMwMDAsIDk4NDAsIFBST1RfUkVBRHxQUk9UX1dS
SVRFLCBNQVBfUFJJVkFURXxNQVBfRklYRUR8TUFQX0FOT05ZTU9VUywgLTEsIDApID0gMHhiN2Y4
YzAwMApjbG9zZSgzKSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPSAwCm1tYXAyKE5V
TEwsIDQwOTYsIFBST1RfUkVBRHxQUk9UX1dSSVRFLCBNQVBfUFJJVkFURXxNQVBfQU5PTllNT1VT
LCAtMSwgMCkgPSAweGI3ZTNmMDAwCnNldF90aHJlYWRfYXJlYSh7ZW50cnlfbnVtYmVyOi0xIC0+
IDYsIGJhc2VfYWRkcjoweGI3ZTNmYWQwLCBsaW1pdDoxMDQ4NTc1LCBzZWdfMzJiaXQ6MSwgY29u
dGVudHM6MCwgcmVhZF9leGVjX29ubHk6MCwgbGltaXRfaW5fcGFnZXM6MSwgc2VnX25vdF9wcmVz
ZW50OjAsIHVzZWFibGU6MX0pID0gMAptcHJvdGVjdCgweGI3Zjg5MDAwLCA0MDk2LCBQUk9UX1JF
QUQpICAgPSAwCmdldHJsaW1pdChSTElNSVRfU1RBQ0ssIHtybGltX2N1cj04MTkyKjEwMjQsIHJs
aW1fbWF4PVJMSU1fSU5GSU5JVFl9KSA9IDAKYnJrKDApICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgID0gMHg4MzRkMDAwCmJyaygweDgzNmUwMDApICAgICAgICAgICAgICAgICAgICAg
ICAgICA9IDB4ODM2ZTAwMApydF9zaWdhY3Rpb24oU0lHSU5ULCB7MHg4MDZhNzcwLCBbXSwgU0Ff
Tk9NQVNLfFNBX09ORVNIT1R9LCBOVUxMLCA4KSA9IDAKcnRfc2lnYWN0aW9uKFNJR1RFUk0sIHsw
eDgwNmE3NzAsIFtdLCBTQV9OT01BU0t8U0FfT05FU0hPVH0sIE5VTEwsIDgpID0gMApydF9zaWdh
Y3Rpb24oU0lHSFVQLCB7MHg4MDZhNzcwLCBbXSwgU0FfTk9NQVNLfFNBX09ORVNIT1R9LCBOVUxM
LCA4KSA9IDAKZnN0YXQ2NCgxLCB7c3RfbW9kZT1TX0lGQ0hSfDA2MjAsIHN0X3JkZXY9bWFrZWRl
digxMzYsIDApLCAuLi59KSA9IDAKbW1hcDIoTlVMTCwgNDA5NiwgUFJPVF9SRUFEfFBST1RfV1JJ
VEUsIE1BUF9QUklWQVRFfE1BUF9BTk9OWU1PVVMsIC0xLCAwKSA9IDB4YjdlM2UwMDAKd3JpdGUo
MSwgIkxvY2F0aW5nIHRoZSB0b3Agb2YgdGhlIGFkZHJlc3MgIi4uLiwgNDIpID0gNDIKcnRfc2ln
YWN0aW9uKFNJR1NFR1YsIHsweDgwNmQ5NTAsIFtdLCBTQV9OT01BU0t9LCB7U0lHX0RGTH0sIDgp
ID0gMAotLS0gU0lHU0VHViAoU2VnbWVudGF0aW9uIGZhdWx0KSBAIDAgKDApIC0tLQptbWFwMihO
VUxMLCA0MDk2LCBQUk9UX1JFQUR8UFJPVF9XUklURSwgTUFQX1BSSVZBVEV8TUFQX0ZJWEVEfE1B
UF9BTk9OWU1PVVMsIC0xLCAwKSA9IC0xIEVBQ0NFUyAoUGVybWlzc2lvbiBkZW5pZWQpCndyaXRl
KDIsICJBZGRyZXNzIDB4MCBubyBnb29kP1xuIiwgMjFBZGRyZXNzIDB4MCBubyBnb29kPwopICA9
IDIxCmV4aXRfZ3JvdXAoMSkgICAgICAgICAgICAgICAgICAgICAgICAgICA9ID8KUHJvY2VzcyAx
MDM3MSBkZXRhY2hlZAo=
------=_Part_808_25700784.1211291954948--
