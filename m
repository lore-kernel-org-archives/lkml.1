Return-Path: <linux-kernel-owner+w=401wt.eu-S1757635AbYCUWOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbYCUWOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbYCUWOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:14:10 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:5627 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbYCUWOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:14:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=OjzLb+G3SB0O8PLJY8btsCfBvG/jonpcuui4Fc/oot+gPMqRckn/0D/R9B5lmh5AdaTgStL6FCXomZhf/+F1EF7ojJ4G2shuUBUkouev6Fguwcoub0oEjvOtXrym+Sbd8wpv8RFZskD65cvnr3VT3b4uvCJdMP9EKudmBN78dLk=
Message-ID: <86802c440803211514k2b3e4bcu626bd37dac0d0f6c@mail.gmail.com>
Date: Fri, 21 Mar 2008 15:14:07 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 0/79] smpboot integration
Cc: "Glauber Costa" <gcosta@redhat.com>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440803211441v30840be4y76d63da567c9af40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_1842_21189434.1206137647934"
References: <12059475744092-git-send-email-gcosta@redhat.com>
	 <86802c440803192000x41a1383fxc2b58ed68e2375b7@mail.gmail.com>
	 <86802c440803192032r2aa15a10pb32ef15fcfc693e7@mail.gmail.com>
	 <47E1EAD6.5080905@redhat.com>
	 <86802c440803192159y28c186f0p98615e90da5a9345@mail.gmail.com>
	 <20080321133327.GN27245@elte.hu>
	 <86802c440803211218t5850ba52w78f8cb9849097ee0@mail.gmail.com>
	 <20080321195506.GB16179@elte.hu>
	 <86802c440803211303m50506ae5ta4c095e40fa1e40d@mail.gmail.com>
	 <86802c440803211441v30840be4y76d63da567c9af40@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_1842_21189434.1206137647934
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, Mar 21, 2008 at 2:41 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> On Fri, Mar 21, 2008 at 1:03 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>  >
>  > On Fri, Mar 21, 2008 at 12:55 PM, Ingo Molnar <mingo@elte.hu> wrote:
>  >  >
>  >  >  * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>  >  >
>  >  >
>  >  > > how to bisect x86.git tree?. it always said it can not bisect seeked
>  >  >  > tree.
>  >  >
>  >  >  ah. Does this work:
>  >  >
>  >  >   git-checkout my-tree x86/latest
>  >  >
>  >  >   git-bisect start
>  >  >   git-bisect good x86/base
>  >  >   git-bisect bad x86/latest
>  >  >
>  >  >  x86/base is the Linus tree that x86.git is based against. You can see
>  >  >  all the x86.git/latest changes by doing:
>  >  >
>  >  >   git-log x86/base..x86/latest
>  >  >
>  >  >         Ingo
>  >  >
>  >
>  >  works. will let you know the result.
>  >
>
>  yhlu@mpk:~/xx/xx/kernel/x86/linux-2.6> git-bisect bad
>  d1c707188ad646c8094cac9afb1738e7d0196ff2 is first bad commit
>  commit d1c707188ad646c8094cac9afb1738e7d0196ff2
>  Author: Glauber de Oliveira Costa <gcosta@redhat.com>
>  Date:   Wed Mar 19 14:25:53 2008 -0300
>
>     x86: include mach_apic.h in smpboot_64.c and smpboot.c
>
>     After the inclusion, a lot of files needs fixing for conflicts,
>     some of them in the headers themselves, to accomodate for both
>     i386 and x86_64 versions.
>
>     [ mingo@elte.hu: build fix ]
>
>     Signed-off-by: Glauber Costa <gcosta@redhat.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
>  :040000 040000 19f574e64bb8003bbe984f3a8c1315db969dfdcd
>  6ffe96588c77bc936705599fa110107856201115 M      arch
>  :040000 040000 61269347ad4f384ed85cc87c4f2d004ed94492ac
>  8f5c713da25579a3cdf63db3d4c2f795261d0521 M      include
>  yhlu@mpk:~/xx/xx/kernel/x86/linux-2.6>
>

attached patch fix that.

YH

------=_Part_1842_21189434.1206137647934
Content-Type: text/x-patch; name=smpboo_intergration_fix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fe3b9fhm0
Content-Disposition: attachment; filename=smpboo_intergration_fix.patch

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvYXNtLXg4Ni9tYWNoLWRlZmF1bHQvbWFjaF9hcGljZGVmLmgg
Yi9pbmNsdWRlL2FzbS14ODYvbWFjaC1kZWZhdWx0L21hY2hfYXBpY2RlZi5oCmluZGV4IDdiNzgy
NzUuLmU0YjI5YmEgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvYXNtLXg4Ni9tYWNoLWRlZmF1bHQvbWFj
aF9hcGljZGVmLmgKKysrIGIvaW5jbHVkZS9hc20teDg2L21hY2gtZGVmYXVsdC9tYWNoX2FwaWNk
ZWYuaApAQCAtNSwxMyArNSwxMiBAQAogCiAjaWZkZWYgQ09ORklHX1g4Nl82NAogI2RlZmluZQlB
UElDX0lEX01BU0sJCSgweEZGdTw8MjQpCisjZGVmaW5lIEdFVF9BUElDX0lEKHgpICAgICAgICAg
ICgoKHgpPj4yNCkmMHhGRnUpCiAjZGVmaW5lCVNFVF9BUElDX0lEKHgpCQkoKCh4KTw8MjQpKQog
I2Vsc2UKICNkZWZpbmUJCUFQSUNfSURfTUFTSwkJKDB4Rjw8MjQpCi0jZW5kaWYKLQogc3RhdGlj
IGlubGluZSB1bnNpZ25lZCBnZXRfYXBpY19pZCh1bnNpZ25lZCBsb25nIHgpIAoteyAKK3sKIAl1
bnNpZ25lZCBpbnQgdmVyID0gR0VUX0FQSUNfVkVSU0lPTihhcGljX3JlYWQoQVBJQ19MVlIpKTsK
IAlpZiAoQVBJQ19YQVBJQyh2ZXIpKQogCQlyZXR1cm4gKCgoeCk+PjI0KSYweEZGKTsKQEAgLTIw
LDUgKzE5LDYgQEAgc3RhdGljIGlubGluZSB1bnNpZ25lZCBnZXRfYXBpY19pZCh1bnNpZ25lZCBs
b25nIHgpCiB9IAogCiAjZGVmaW5lCQlHRVRfQVBJQ19JRCh4KQlnZXRfYXBpY19pZCh4KQorI2Vu
ZGlmCiAKICNlbmRpZgo=
------=_Part_1842_21189434.1206137647934--
