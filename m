Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbYCRIh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbYCRIh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 04:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbYCRIhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 04:37:48 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:9132 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYCRIhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 04:37:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=RmEN/q1s6jz+oByRpXrfEHzrIDfxjUdlotOYDkxsUrh+7cBukeQ2/5P+6Zzu59kuA4wXkrHTglVq8iAIFhLSwZB3Kk6GWF/Nn/8f3+mmsy1bCChSzNmazr5+5c2O+ATjp8la/LZWy5wmzrM5x6OyDorFepznI11B5yH+slHZp/M=
Message-ID: <86802c440803180137v3af27da5jd34f2b8c90e6209d@mail.gmail.com>
Date: Tue, 18 Mar 2008 01:37:46 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Ravikiran Thirumalai" <kiran@scalemp.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Glauber Costa" <gcosta@redhat.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
Subject: Fwd: + x86-vsmp-build-fixes.patch added to -mm tree
Cc: "Linux Kernel ML" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440803180125rc604cf3l4ad9fe13f4060140@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_19970_26211403.1205829466503"
References: <200803180514.m2I5ElVJ015693@imap1.linux-foundation.org>
	 <86802c440803172226yb867326rb595b36b03e6c4b9@mail.gmail.com>
	 <20080318072802.GH6091@localdomain>
	 <86802c440803180125rc604cf3l4ad9fe13f4060140@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_19970_26211403.1205829466503
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

add akpm


---------- Forwarded message ----------
From: Yinghai Lu <yhlu.kernel@gmail.com>
Date: Tue, Mar 18, 2008 at 1:25 AM
Subject: Re: + x86-vsmp-build-fixes.patch added to -mm tree
To: Ravikiran Thirumalai <kiran@scalemp.com>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
gcosta@redhat.com, mingo@elte.hu, tglx@linutronix.de


On Tue, Mar 18, 2008 at 12:28 AM, Ravikiran Thirumalai
 <kiran@scalemp.com> wrote:
 > On Mon, Mar 17, 2008 at 10:26:55PM -0700, Yinghai Lu wrote:
 >  >On Mon, Mar 17, 2008 at 10:14 PM,  <akpm@linux-foundation.org> wrote:
 >  >> ...
 >
 > >>  Subject: x86: vsmp build fixes
 >  >>  From: Glauber Costa <gcosta@redhat.com>
 >  >>
 >  >>  VSMP depends on PCI, but the file is now compiled
conditionally on PARAVIRT,
 >  >>  no VSMP, so enclose everything in an ifdef CONFIG_PCI.
 >
 >  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 >  ...
 >
 > >
 >  >in arch/x86/Kconfig
 >  >
 >  >config PCI
 >  >        bool "PCI support" if !X86_VISWS && !X86_VSMP
 >  >        depends on !X86_VOYAGER
 >  >        default y
 >  >        select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)
 >  >        help
 >  >          Find out whether you have a PCI motherboard. PCI is the name of a
 >  >          bus system, i.e. the way the CPU talks to the other stuff inside
 >  >          your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
 >  >          VESA. If you have PCI, say Y, otherwise N.
 >  >
 >  >will make sure if X86_VSMP, the PCI=y
 >  >
 >  >so NAK this patch.
 >  >
 >
 >  Not really, as you can tell from the description Glauber provided above.
 >
 suggest you change vsmp_64.c still depend to CONFIG_VSMP, and add some
 inline function in some header file.
 sth like attach patch

 YH

------=_Part_19970_26211403.1205829466503
Content-Type: text/x-patch; name=vsmp_init.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdy7byfi0
Content-Disposition: attachment; filename=vsmp_init.patch

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9NYWtlZmlsZSBiL2FyY2gveDg2L2tlcm5lbC9N
YWtlZmlsZQppbmRleCAwOWI3YjRlLi4wMGMwMDEwIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJu
ZWwvTWFrZWZpbGUKKysrIGIvYXJjaC94ODYva2VybmVsL01ha2VmaWxlCkBAIC02MSw3ICs2MSw3
IEBAIG9iai0kKENPTkZJR19LRVhFQykJCSs9IHJlbG9jYXRlX2tlcm5lbF8kKEJJVFMpLm8gY3Jh
c2gubwogb2JqLSQoQ09ORklHX0NSQVNIX0RVTVApCSs9IGNyYXNoX2R1bXBfJChCSVRTKS5vCiBv
YmotJChDT05GSUdfWDg2X05VTUFRKQkJKz0gbnVtYXFfMzIubwogb2JqLSQoQ09ORklHX1g4Nl9T
VU1NSVRfTlVNQSkJKz0gc3VtbWl0XzMyLm8KLW9iai0kKENPTkZJR19QQVJBVklSVCkJCSs9IHZz
bXBfNjQubworb2JqLSQoQ09ORklHX1g4Nl9WU01QKQkJKz0gdnNtcF82NC5vCiBvYmotJChDT05G
SUdfS1BST0JFUykJCSs9IGtwcm9iZXMubwogb2JqLSQoQ09ORklHX01PRFVMRVMpCQkrPSBtb2R1
bGVfJChCSVRTKS5vCiBvYmotJChDT05GSUdfQUNQSV9TUkFUKSAJKz0gc3JhdF8zMi5vCmRpZmYg
LS1naXQgYS9pbmNsdWRlL2FzbS14ODYvYXBpYy5oIGIvaW5jbHVkZS9hc20teDg2L2FwaWMuaApp
bmRleCBkYjVmNzUwLi42YmNmNTU5IDEwMDY0NAotLS0gYS9pbmNsdWRlL2FzbS14ODYvYXBpYy5o
CisrKyBiL2luY2x1ZGUvYXNtLXg4Ni9hcGljLmgKQEAgLTUxLDEzICs1MSwxNyBAQCBleHRlcm4g
dW5zaWduZWQgYm9vdF9jcHVfaWQ7CiAgKi8KICNpZmRlZiBDT05GSUdfUEFSQVZJUlQKICNpbmNs
dWRlIDxhc20vcGFyYXZpcnQuaD4KLWV4dGVybiBpbnQgaXNfdnNtcF9ib3godm9pZCk7CiAjZWxz
ZQogI2RlZmluZSBhcGljX3dyaXRlIG5hdGl2ZV9hcGljX3dyaXRlCiAjZGVmaW5lIGFwaWNfd3Jp
dGVfYXRvbWljIG5hdGl2ZV9hcGljX3dyaXRlX2F0b21pYwogI2RlZmluZSBhcGljX3JlYWQgbmF0
aXZlX2FwaWNfcmVhZAogI2RlZmluZSBzZXR1cF9ib290X2Nsb2NrIHNldHVwX2Jvb3RfQVBJQ19j
bG9jawogI2RlZmluZSBzZXR1cF9zZWNvbmRhcnlfY2xvY2sgc2V0dXBfc2Vjb25kYXJ5X0FQSUNf
Y2xvY2sKKyNlbmRpZgorCisjaWZkZWYgQ09ORklHX1g4Nl9WU01QCitleHRlcm4gaW50IGlzX3Zz
bXBfYm94KHZvaWQpOworI2Vsc2UKIHN0YXRpYyBpbnQgaW5saW5lIGlzX3ZzbXBfYm94KHZvaWQp
CiB7CiAJcmV0dXJuIDA7CmRpZmYgLS1naXQgYS9pbmNsdWRlL2FzbS14ODYvc2V0dXAuaCBiL2lu
Y2x1ZGUvYXNtLXg4Ni9zZXR1cC5oCmluZGV4IGY3NDVkZTIuLjg1MTY1NTAgMTAwNjQ0Ci0tLSBh
L2luY2x1ZGUvYXNtLXg4Ni9zZXR1cC5oCisrKyBiL2luY2x1ZGUvYXNtLXg4Ni9zZXR1cC5oCkBA
IC02LDcgKzYsMTMgQEAKICNpZm5kZWYgX19BU1NFTUJMWV9fCiAKIC8qIEludGVycnVwdCBjb250
cm9sIGZvciB2U01Qb3dlcmVkIHg4Nl82NCBzeXN0ZW1zICovCisjaWZkZWYgQ09ORklHX1g4Nl9W
U01QCiB2b2lkIHZzbXBfaW5pdCh2b2lkKTsKKyNlbHNlCitzdGF0aWMgaW5saW5lIHZvaWQgdnNt
cF9pbml0KHZvaWQpCit7Cit9CisjZW5kaWYKIAogY2hhciAqbWFjaGluZV9zcGVjaWZpY19tZW1v
cnlfc2V0dXAodm9pZCk7CiAjaWZuZGVmIENPTkZJR19QQVJBVklSVAo=
------=_Part_19970_26211403.1205829466503--
