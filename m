Return-Path: <linux-kernel-owner+w=401wt.eu-S1765644AbYECR3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765644AbYECR3z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762675AbYECR3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:29:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:31554 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762489AbYECR3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:29:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=ueWpZ99aYE9qkPdtQNmpBl0iWCAjrRq7SrmfPA5mDFZlKFdLAlh9AS7u/uPgoIKQR3w+7IEJHdXAynwXFHG6pjDNPviZcjpGPKZWrFhLT3leiPeIpnRLvhoP0a0m7zm068m7VqPolYWWJJ5fTUz5ofTWSYPinpllg866VsJ/pPg=
Message-ID: <32209efe0805031029q513f536brc7af5fce984bbfb0@mail.gmail.com>
Date: Sat, 3 May 2008 10:29:44 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for April 11 (x86-es7000)
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080411144501.a7191e0b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_6097_6566182.1209835784892"
References: <20080411173622.ea3f3624.sfr@canb.auug.org.au>
	 <20080411144501.a7191e0b.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_6097_6566182.1209835784892
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, Apr 11, 2008 at 2:45 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Fri, 11 Apr 2008 17:36:22 +1000 Stephen Rothwell wrote:
>
> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> > (tar balls at
> > http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).
>
>
> In mainline, x86-32-subarch es7000 builds cleanly.
> .config attached.  (CONFIG_ACPI=n)
>
>
> In linux-next, the same .config (with minimal -next changes) fails:
>
> arch/x86/mach-es7000/built-in.o: In function `es7000_rename_gsi':
> next-20080411/arch/x86/mach-es7000/es7000plat.c:64: undefined reference to `es7000_plat'
> arch/x86/mach-es7000/built-in.o: In function `setup_unisys':
> next-20080411/arch/x86/mach-es7000/es7000plat.c:89: undefined reference to `es7000_plat'
> next-20080411/arch/x86/mach-es7000/es7000plat.c:91: undefined reference to `es7000_plat'
> arch/x86/mach-es7000/built-in.o: In function `parse_unisys_oem':
> next-20080411/arch/x86/mach-es7000/es7000plat.c:156: undefined reference to `es7000_plat'
> next-20080411/arch/x86/mach-es7000/es7000plat.c:154: undefined reference to `es7000_plat'
> arch/x86/mach-es7000/built-in.o:next-20080411/arch/x86/mach-es7000/es7000plat.c:156: more undefined references to `es7000_plat' follow
> make[1]: *** [.tmp_vmlinux1] Error 1
>
> ---
> ~Randy
>

From: Natalie Protasevich <protasnb@gmail.com>

This is the patch to fix build problem with es7000.
Conflict while building without ACPI being set. Made es7000_plat to be
defined in both ACPI and non-ACPI cases.

Signed-off-by: Natalie Protasevich <protasnb@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
mpparse.c |    4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

diff -Naur linux-next/arch/x86/kernel/mpparse.c
linux-next-mod/arch/x86/kernel/mpparse.c
--- linux-next/arch/x86/kernel/mpparse.c        2008-05-02
14:26:02.000000000 -0700
+++ linux-next-mod/arch/x86/kernel/mpparse.c    2008-05-02
14:34:00.000000000 -0700
@@ -790,6 +790,8 @@
        __find_smp_config(1);
 }

+int es7000_plat;
+
 /* --------------------------------------------------------------------------
                             ACPI-based MP Configuration
    --------------------------------------------------------------------------
*/
@@ -909,8 +911,6 @@
        MP_intsrc_info(&intsrc);
 }

-int es7000_plat;
-
 void __init mp_config_acpi_legacy_irqs(void)
 {
        struct mpc_config_intsrc intsrc;





Thanks,
--Natalie

------=_Part_6097_6566182.1209835784892
Content-Type: text/x-patch; name=es7000-build-fix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ffsgxmex1
Content-Disposition: attachment; filename=es7000-build-fix.patch

RnJvbTogTmF0YWxpZSBQcm90YXNldmljaCA8cHJvdGFzbmJAZ21haWwuY29tPgoKVGhpcyBpcyB0
aGUgcGF0Y2ggdG8gZml4IGJ1aWxkIHByb2JsZW0gd2l0aCBlczcwMDAuCkNvbmZsaWN0IHdoaWxl
IGJ1aWxkaW5nIHdpdGhvdXQgQUNQSSBiZWluZyBzZXQuIE1hZGUgZXM3MDAwX3BsYXQgdG8gYmUg
ZGVmaW5lZCBmb3IgYm90aCBBQ1BJIGFuZCBub24tQUNQSSBjYXNlcy4KClNpZ25lZC1vZmYtYnk6
IE5hdGFsaWUgUHJvdGFzZXZpY2ggPHByb3Rhc25iQGdtYWlsLmNvbT4KU2lnbmVkLW9mZi1ieTog
UmFuZHkgRHVubGFwIDxyYW5keS5kdW5sYXBAb3JhY2xlLmNvbT4KLS0tIAptcHBhcnNlLmMgfCAg
ICA0ICsrLS0KMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkK
CgpkaWZmIC1OYXVyIGxpbnV4LW5leHQvYXJjaC94ODYva2VybmVsL21wcGFyc2UuYyBsaW51eC1u
ZXh0LW1vZC9hcmNoL3g4Ni9rZXJuZWwvbXBwYXJzZS5jCi0tLSBsaW51eC1uZXh0L2FyY2gveDg2
L2tlcm5lbC9tcHBhcnNlLmMJMjAwOC0wNS0wMiAxNDoyNjowMi4wMDAwMDAwMDAgLTA3MDAKKysr
IGxpbnV4LW5leHQtbW9kL2FyY2gveDg2L2tlcm5lbC9tcHBhcnNlLmMJMjAwOC0wNS0wMiAxNDoz
NDowMC4wMDAwMDAwMDAgLTA3MDAKQEAgLTc5MCw2ICs3OTAsOCBAQAogCV9fZmluZF9zbXBfY29u
ZmlnKDEpOwogfQogCitpbnQgZXM3MDAwX3BsYXQ7CisKIC8qIC0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgQUNQSS1iYXNlZCBNUCBDb25maWd1cmF0aW9uCiAg
ICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLSAqLwpAQCAtOTA5LDggKzkxMSw2IEBACiAJTVBfaW50c3JjX2lu
Zm8oJmludHNyYyk7CiB9CiAKLWludCBlczcwMDBfcGxhdDsKLQogdm9pZCBfX2luaXQgbXBfY29u
ZmlnX2FjcGlfbGVnYWN5X2lycXModm9pZCkKIHsKIAlzdHJ1Y3QgbXBjX2NvbmZpZ19pbnRzcmMg
aW50c3JjOwo=
------=_Part_6097_6566182.1209835784892--
