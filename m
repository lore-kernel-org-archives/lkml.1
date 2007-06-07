Return-Path: <linux-kernel-owner+w=401wt.eu-S1764892AbXFGQdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764892AbXFGQdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757834AbXFGQdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:33:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:28550 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbXFGQdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:33:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=Fv1q3kUghxqagt5FtJRerkmqtlk5aQky6p0mvb8D7nWWE6+pMktSQifW+jaI9qWZ4wKcubDrI93SmEtKYPC9lyElgRFvFgEfIzKE0mjBf35/5rwsP5WUcmdGZZ1LnpTNwr1mujQ4/HynAidQrGmnoZYXALXA085fIIUpyaaj3e0=
Message-ID: <a781481a0706070933ld67e06escaddf1b7be2b017@mail.gmail.com>
Date: Thu, 7 Jun 2007 22:03:08 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make smp_call_function{_single} go WARNING and return -EINVAL on !SMP (was Re: [PATCH] i386/x86_64: NMI watchdog: Protect smp_call_function() within CONFIG_SMP)
Cc: "Ingo Molnar" <mingo@redhat.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Alan Cox" <alan@redhat.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>
In-Reply-To: <a781481a0706070848j2256cc1elea8723778ab7da5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_42663_7061120.1181233988987"
References: <a781481a0706070848j2256cc1elea8723778ab7da5b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_42663_7061120.1181233988987
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

> On 6/7/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> > [...]
> > BTW: smp_call_function() simply returns 0 and
> > smp_call_function_single() simply returns -EBUSY when !SMP.
> > These appear to be just some ad hoc values. IMHO, we should
> > be going BUG() in both these cases because "other" CPUs for
> > !SMP are undefined / meaningless.
>
> 79974a0e4c6be6e9a3717b4c5a5d5c44c36b1653 from a couple
> weeks back (discussed on http://lkml.org/lkml/2007/5/14/68 i.e.
> [patch] Let smp_call_function_single return -EBUSY.) introduced
> this behaviour. [ Adding Heiko Carstens, Andrew and David Miller
> to Cc: list. ]
>
> I realized a warning would be more appropriate for this case than
> a BUG at the last moment ... this doesn't quite meet Linus' "You
> killed my father; prepare to die!" criterion :-)

Ugh, Gmail murdered this patch:

>  static inline int smp_call_function_single(int cpuid, void (*func)
> (void *info),
>                                            void *info, int retry, int wait)

Resending as attachment.

------=_Part_42663_7061120.1181233988987
Content-Type: text/x-patch; 
	name=make-smp_call_function-go-warning-on-up.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f2ngkvyc
Content-Disposition: attachment; filename="make-smp_call_function-go-warning-on-up.patch"

W1BBVENIXSBNYWtlIHNtcF9jYWxsX2Z1bmN0aW9ue19zaW5nbGV9IGdvIFdBUk5JTkcgYW5kIHJl
dHVybiAtRUlOVkFMIG9uICFTTVAKClRoZSBzbXBfY2FsbF9mdW5jdGlvbntfc2luZ2xlfSBmdW5j
dGlvbnMgYXJlIHVzZWQgdG8gcnVuCmdpdmVuIGZ1bmN0aW9uIG9uIGFsbCB7b3Igc3BlaWNpZmll
ZH0gKm90aGVyKiBDUFVzLiBGb3IKVVAgc3lzdGVtcywgIm90aGVyIiBDUFVzIHNpbXBseSBkb24n
dCBleGlzdCwgc28gd2UgZmxhZwpzdWNoIGluY29ycmVjdCB1c2FnZSBvZiB0aGVzZSBmdW5jdGlv
bnMgdXNpbmcgYSBXQVJOSU5HLgoKQWxzbywgLUVCVVNZIGlzIGdlbmVyYWxseSByZXR1cm5lZCBi
eSBhcmNoIGltcGxlbWVudGF0aW9ucwp3aGVuIHRoZXkgZmluZCB0aGF0IHRhcmdldF9jcHUgPT0g
Y3VycmVudF9jcHUsIHdoaWNoIGlzIG5vdAphIGNvbXBhcmFibGUgY2FzZSB0byB0aGUgIVNNUCBj
YXNlLiBVc2UgLUVJTlZBTCBpbnN0ZWFkLApzaW1pbGFyIHRvIHdoYXQgcG93ZXJwYyBkb2VzIGZv
ciAhY3B1X29ubGluZSh0YXJnZXQpLCB3aGljaAppcyBzb21ld2hhdCBtb3JlIGFuYWxvZ291cy4K
ClNpZ25lZC1vZmYtYnk6IFNhdHlhbSBTaGFybWEgPHNzYXR5YW1AY3NlLmlpdGsuYWMuaW4+CkNj
OiBJbmdvIE1vbG5hciA8bWluZ29AcmVkaGF0LmNvbT4KQ2M6IEFuZGkgS2xlZW4gPGFuZGlAZmly
c3RmbG9vci5vcmc+CkNjOiBBbGFuIENveCA8YWxhbkByZWRoYXQuY29tPgpDYzogSGVpa28gQ2Fy
c3RlbnMgPGhlaWtvLmNhcnN0ZW5zQGRlLmlibS5jb20+CkNjOiBBbmRyZXcgTW9ydG9uIDxha3Bt
QGxpbnV4LWZvdW5kYXRpb24ub3JnPgpDYzogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQu
bmV0PgoKLS0tCgogaW5jbHVkZS9saW51eC9zbXAuaCB8ICAgMTcgKysrKysrKysrKy0tLS0tLS0K
IDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQoKLS0tCgpk
aWZmIC1ydU5wIGEvaW5jbHVkZS9saW51eC9zbXAuaCBiL2luY2x1ZGUvbGludXgvc21wLmgKLS0t
IGEvaW5jbHVkZS9saW51eC9zbXAuaAkyMDA3LTA2LTA3IDEyOjQ2OjUwLjAwMDAwMDAwMCArMDUz
MAorKysgYi9pbmNsdWRlL2xpbnV4L3NtcC5oCTIwMDctMDYtMDcgMjI6MDI6MzQuMDAwMDAwMDAw
ICswNTMwCkBAIC02LDYgKzYsNyBAQAogICoJCUFsYW4gQ294LiA8YWxhbkByZWRoYXQuY29tPgog
ICovCiAKKyNpbmNsdWRlIDxsaW51eC9idWcuaD4KICNpbmNsdWRlIDxsaW51eC9lcnJuby5oPgog
CiBleHRlcm4gdm9pZCBjcHVfaWRsZSh2b2lkKTsKQEAgLTg0LDExICs4NSw2IEBAIHZvaWQgc21w
X3ByZXBhcmVfYm9vdF9jcHUodm9pZCk7CiAgKglUaGVzZSBtYWNyb3MgZm9sZCB0aGUgU01QIGZ1
bmN0aW9uYWxpdHkgaW50byBhIHNpbmdsZSBDUFUgc3lzdGVtCiAgKi8KICNkZWZpbmUgcmF3X3Nt
cF9wcm9jZXNzb3JfaWQoKQkJCTAKLXN0YXRpYyBpbmxpbmUgaW50IHVwX3NtcF9jYWxsX2Z1bmN0
aW9uKHZvaWQpCi17Ci0JcmV0dXJuIDA7Ci19Ci0jZGVmaW5lIHNtcF9jYWxsX2Z1bmN0aW9uKGZ1
bmMsaW5mbyxyZXRyeSx3YWl0KQkodXBfc21wX2NhbGxfZnVuY3Rpb24oKSkKICNkZWZpbmUgb25f
ZWFjaF9jcHUoZnVuYyxpbmZvLHJldHJ5LHdhaXQpCVwKIAkoewkJCQkJXAogCQlsb2NhbF9pcnFf
ZGlzYWJsZSgpOwkJXApAQCAtOTksMTAgKzk1LDE3IEBAIHN0YXRpYyBpbmxpbmUgaW50IHVwX3Nt
cF9jYWxsX2Z1bmN0aW9uKHYKIHN0YXRpYyBpbmxpbmUgdm9pZCBzbXBfc2VuZF9yZXNjaGVkdWxl
KGludCBjcHUpIHsgfQogI2RlZmluZSBudW1fYm9vdGluZ19jcHVzKCkJCQkxCiAjZGVmaW5lIHNt
cF9wcmVwYXJlX2Jvb3RfY3B1KCkJCQlkbyB7fSB3aGlsZSAoMCkKLXN0YXRpYyBpbmxpbmUgaW50
IHNtcF9jYWxsX2Z1bmN0aW9uX3NpbmdsZShpbnQgY3B1aWQsIHZvaWQgKCpmdW5jKSAodm9pZCAq
aW5mbyksCitzdGF0aWMgaW5saW5lIGludCBzbXBfY2FsbF9mdW5jdGlvbih2b2lkICgqZnVuYyko
dm9pZCAqaW5mbyksCisJCQkJICAgIHZvaWQgKmluZm8sIGludCByZXRyeSwgaW50IHdhaXQpCit7
CisJV0FSTl9PTigxKTsKKwlyZXR1cm4gLUVJTlZBTDsKK30KK3N0YXRpYyBpbmxpbmUgaW50IHNt
cF9jYWxsX2Z1bmN0aW9uX3NpbmdsZShpbnQgY3B1aWQsIHZvaWQgKCpmdW5jKSh2b2lkICppbmZv
KSwKIAkJCQkJICAgdm9pZCAqaW5mbywgaW50IHJldHJ5LCBpbnQgd2FpdCkKIHsKLQlyZXR1cm4g
LUVCVVNZOworCVdBUk5fT04oMSk7CisJcmV0dXJuIC1FSU5WQUw7CiB9CiAKICNlbmRpZiAvKiAh
U01QICovCg==
------=_Part_42663_7061120.1181233988987--
