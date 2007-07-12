Return-Path: <linux-kernel-owner+w=401wt.eu-S1762107AbXGLH0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762107AbXGLH0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 03:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754360AbXGLH0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 03:26:13 -0400
Received: from [222.92.8.141] ([222.92.8.141]:49257 "HELO lemote.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1753257AbXGLH0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 03:26:11 -0400
Message-ID: <4695D78F.8010806@lemote.com>
Date: Thu, 12 Jul 2007 15:26:07 +0800
From: Songmao Tian <tiansm@lemote.com>
User-Agent: Icedove 1.5.0.8 (X11/20061116)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: LinuxBIOS Mailing List <linuxbios@linuxbios.org>, marc.jones@amd.com,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: about cs5536 interrupt ack
References: <4694A495.1050006@lemote.com> <Pine.LNX.4.64N.0707111347360.26459@blysk.ds.pg.gda.pl> <4694F4EB.8040000@lemote.com> <Pine.LNX.4.64N.0707111634430.26459@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0707111634430.26459@blysk.ds.pg.gda.pl>
Content-Type: multipart/mixed;
 boundary="------------000806090703090504080000"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000806090703090504080000
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

8259 problem  seems to be done with the attached patch, IDE hung seems 
to be the dma setting problem.

Thanks all for your advise, comments. I have learned a lot. now I 
continue to trace down the IDE problem.

Mao

Maciej W. Rozycki wrote:
> On Wed, 11 Jul 2007, Songmao Tian wrote:
>
>   
>>> Huh?  Have you managed to find an 8259A clone *that* broken?  So what does
>>> it return if you write 0xc to the address 0x20 in the I/O port space and
>>> then read back from that location?  You should complain to the 
>>>   
>>>       
>> It's the value of IRR, so guess IRR. AMD has well documented cs5536, I
>> appreciate that.
>>     
>
>  Indeed.  I am surprised they have decided to drop the poll command -- it 
> surely does not require much logic as it mostly reuses what's used to 
> produce the vector anyway and it is commonly used when 8259A 
> implementations are interfaced to non-i386 processors.  PPC is another 
> example.
>
>   
>>> More or less -- 3-5 should probably be the outcome of a single read
>>> transaction from the north bridge.  I.e. you issue a read to a "magic"
>>> location, 3-5 happen, and the data value returned is the vector presented by
>>> the interrupt controller on the PCI bus.
>>>   
>>>       
>> yeah, we can implement a register in north bridge.
>>     
>
>  Strictly speaking it would not be a register, but a "PCI INTA address 
> space" much like PCI memory or I/O port address spaces.  Though as the 
> former ignores addresses driven on the bus, the space occupied does not 
> have to be extensive -- I would assume whatever slot size is available 
> with the address decoder you have implemented would do.
>
>   
>>> You can still dispatch interrupts manually by examining the IRR register,
>>> but having a way to ask the 8259A's prioritiser would be nice.  Although
>>> given such a lethal erratum you report I would not count on the prioritiser
>>> to provide any useful flexibility...
>>>   
>>>       
>> yeah, that's a straight thought, tried but failed:(, patch followed.
>>     
>
>  You may have to modify other functions from arch/mips/kernel/i8259.c; 
> yes, this makes the whole experience not as pretty as one would hope...
>
>   Maciej
>
>
>
>   


--------------000806090703090504080000
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="diff"

ZGlmZiAtLWdpdCBhL2FyY2gvbWlwcy9rZXJuZWwvaTgyNTkuYyBiL2FyY2gvbWlwcy9rZXJu
ZWwvaTgyNTkuYwppbmRleCA5Yzc5NzAzLi5mZDdmNGJhIDEwMDY0NAotLS0gYS9hcmNoL21p
cHMva2VybmVsL2k4MjU5LmMKKysrIGIvYXJjaC9taXBzL2tlcm5lbC9pODI1OS5jCkBAIC00
NywxMSArNDcsNyBAQCBzdGF0aWMgc3RydWN0IGlycV9jaGlwIGk4MjU5QV9jaGlwID0gewog
LyoKICAqIFRoaXMgY29udGFpbnMgdGhlIGlycSBtYXNrIGZvciBib3RoIDgyNTlBIGlycSBj
b250cm9sbGVycywKICAqLwotc3RhdGljIHVuc2lnbmVkIGludCBjYWNoZWRfaXJxX21hc2sg
PSAweGZmZmY7Ci0KLSNkZWZpbmUgY2FjaGVkX21hc3Rlcl9tYXNrCShjYWNoZWRfaXJxX21h
c2spCi0jZGVmaW5lIGNhY2hlZF9zbGF2ZV9tYXNrCShjYWNoZWRfaXJxX21hc2sgPj4gOCkK
LQordW5zaWduZWQgaW50IGNhY2hlZF9pcnFfbWFzayA9IDB4ZmZmZjsKIHZvaWQgZGlzYWJs
ZV84MjU5QV9pcnEodW5zaWduZWQgaW50IGlycSkKIHsKIAl1bnNpZ25lZCBpbnQgbWFzazsK
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvYXNtLW1pcHMvaTgyNTkuaCBiL2luY2x1ZGUvYXNtLW1p
cHMvaTgyNTkuaAppbmRleCBlODhhMDE2Li5lN2RjZjdiIDEwMDY0NAotLS0gYS9pbmNsdWRl
L2FzbS1taXBzL2k4MjU5LmgKKysrIGIvaW5jbHVkZS9hc20tbWlwcy9pODI1OS5oCkBAIC0z
NywxMSArMzcsNTUgQEAKIAogZXh0ZXJuIHNwaW5sb2NrX3QgaTgyNTlBX2xvY2s7CiAKK2V4
dGVybiB1bnNpZ25lZCBpbnQgY2FjaGVkX2lycV9tYXNrOworI2RlZmluZSBjYWNoZWRfbWFz
dGVyX21hc2sJKGNhY2hlZF9pcnFfbWFzaykKKyNkZWZpbmUgY2FjaGVkX3NsYXZlX21hc2sJ
KGNhY2hlZF9pcnFfbWFzayA+PiA4KQorCiBleHRlcm4gdm9pZCBpbml0XzgyNTlBKGludCBh
dXRvX2VvaSk7CiBleHRlcm4gdm9pZCBlbmFibGVfODI1OUFfaXJxKHVuc2lnbmVkIGludCBp
cnEpOwogZXh0ZXJuIHZvaWQgZGlzYWJsZV84MjU5QV9pcnEodW5zaWduZWQgaW50IGlycSk7
CiAKIGV4dGVybiB2b2lkIGluaXRfaTgyNTlfaXJxcyh2b2lkKTsKKyNkZWZpbmUgQ09ORklH
X05PX0lOVEVSUlVQVF9BQ0sKKyNpZmRlZiBDT05GSUdfTk9fSU5URVJSVVBUX0FDSworc3Rh
dGljIGlubGluZSBpbnQgX2J5dGVfZmZzKHU4IHdvcmQpCit7CisJaW50IG51bSA9IDA7CisJ
aWYgKCh3b3JkICYgMHhmKSA9PSAwKSB7CisJCW51bSArPSA0OworCQl3b3JkID4+PSA0Owor
CX0KKwlpZiAoKHdvcmQgJiAweDMpID09IDApIHsKKwkJbnVtICs9IDI7CisJCXdvcmQgPj49
IDI7CisJfQorCWlmICgod29yZCAmIDB4MSkgPT0gMCkKKwkJbnVtICs9IDE7CisJcmV0dXJu
IG51bTsKK30KKworc3RhdGljIGlubGluZSBpbnQgcmVhZF9pcnEoaW50IHBvcnQpCit7CisJ
aW50IGlycTsKKwlvdXRiKDB4MEEsIHBvcnQpOworCWlmIChwb3J0ID09IFBJQ19NQVNURVJf
Q01EKSB7CisJCWlycSA9IGluYihwb3J0KSAmIH5jYWNoZWRfbWFzdGVyX21hc2s7CisJfSBl
bHNlIHsKKwkJaXJxID0gaW5iKHBvcnQpICYgfmNhY2hlZF9zbGF2ZV9tYXNrOworCX0KKwlp
ZiAoaXJxID09IDApCisJCXJldHVybiAtMTsKKwllbHNlCisJCXJldHVybiBfYnl0ZV9mZnMo
aXJxKTsKK30KKyNlbHNlCitzdGF0aWMgaW5saW5lIGludCByZWFkX2lycShpbnQgcG9ydCkK
K3sKKwkvKiBQZXJmb3JtIGFuIGludGVycnVwdCBhY2tub3dsZWRnZSBjeWNsZSBvbiBjb250
cm9sbGVyIDEuICovCisJb3V0YigweDBDLCBwb3J0KTsJCS8qIHByZXBhcmUgZm9yIHBvbGwg
Ki8KKwlyZXR1cm4gaW5iKHBvcnQpICYgNzsKK30KKyNlbmRpZgogCiAvKgogICogRG8gdGhl
IHRyYWRpdGlvbmFsIGk4MjU5IGludGVycnVwdCBwb2xsaW5nIHRoaW5nLiAgVGhpcyBpcyBm
b3IgdGhlIGZldwpAQCAtNTQsMTggKzk4LDE2IEBAIHN0YXRpYyBpbmxpbmUgaW50IGk4MjU5
X2lycSh2b2lkKQogCiAJc3Bpbl9sb2NrKCZpODI1OUFfbG9jayk7CiAKLQkvKiBQZXJmb3Jt
IGFuIGludGVycnVwdCBhY2tub3dsZWRnZSBjeWNsZSBvbiBjb250cm9sbGVyIDEuICovCi0J
b3V0YigweDBDLCBQSUNfTUFTVEVSX0NNRCk7CQkvKiBwcmVwYXJlIGZvciBwb2xsICovCi0J
aXJxID0gaW5iKFBJQ19NQVNURVJfQ01EKSAmIDc7CisJaXJxID0gcmVhZF9pcnEoUElDX01B
U1RFUl9DTUQpOwogCWlmIChpcnEgPT0gUElDX0NBU0NBREVfSVIpIHsKIAkJLyoKIAkJICog
SW50ZXJydXB0IGlzIGNhc2NhZGVkIHNvIHBlcmZvcm0gaW50ZXJydXB0CiAJCSAqIGFja25v
d2xlZGdlIG9uIGNvbnRyb2xsZXIgMi4KIAkJICovCi0JCW91dGIoMHgwQywgUElDX1NMQVZF
X0NNRCk7CQkvKiBwcmVwYXJlIGZvciBwb2xsICovCi0JCWlycSA9IChpbmIoUElDX1NMQVZF
X0NNRCkgJiA3KSArIDg7Ci0JfQorCQlpcnEgPSByZWFkX2lycShQSUNfU0xBVkVfQ01EKSAr
IDg7CisJfSAKIAorI2lmbmRlZiBDT05GSUdfTk9fSU5URVJSVVBUX0FDSwogCWlmICh1bmxp
a2VseShpcnEgPT0gNykpIHsKIAkJLyoKIAkJICogVGhpcyBtYXkgYmUgYSBzcHVyaW91cyBp
bnRlcnJ1cHQuCkBAIC03OCw2ICsxMjAsMTEgQEAgc3RhdGljIGlubGluZSBpbnQgaTgyNTlf
aXJxKHZvaWQpCiAJCWlmKH5pbmIoUElDX01BU1RFUl9JU1IpICYgMHg4MCkKIAkJCWlycSA9
IC0xOwogCX0KKyNlbHNlCisJaWYgKGNhY2hlZF9pcnFfbWFzayAmICgxIDw8IGlycSkpIHsK
KwkJaXJxID0gLTE7CisJfQorI2VuZGlmCiAKIAlzcGluX3VubG9jaygmaTgyNTlBX2xvY2sp
OwogCg==
--------------000806090703090504080000--
