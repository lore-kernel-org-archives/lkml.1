Return-Path: <linux-kernel-owner+w=401wt.eu-S1761401AbYEGCl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbYEGCl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 22:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760558AbYEGCkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 22:40:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:39140 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579AbYEGCjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 22:39:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=K6vm63tDLilnrKH1Yqv8p8YQy3DuV/J8+14g8jlLZbP3Cp4kPHk9ERVFdWq7PVPJ/doBB7xIWKrdhk/FVe7KQBU2c6mW43rX3AX52EFmfN4UKEz/y4nQLiRSTfcuoFhTOtHTXO4hzDAHRrYMYgHFWmgOSaMGA+EuiLWM4yvjsSQ=
Message-ID: <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>
Date: Tue, 6 May 2008 19:39:44 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rene Herman" <rene.herman@keyaccess.nl>
Subject: Re: 2.6.26, PAT and AMD family 6
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <48210A71.1060409@keyaccess.nl>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_20814_22758030.1210127985006"
References: <48210A71.1060409@keyaccess.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_20814_22758030.1210127985006
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, May 6, 2008 at 6:48 PM, Rene Herman <rene.herman@keyaccess.nl> wrote:
> Good day.
>
>  On 2.6.25 and below, my /proc/cpuinfo looks like:
>
>  processor       : 0
>  vendor_id       : AuthenticAMD
>  cpu family      : 6
>  model           : 7
>  model name      : AMD Duron(tm) Processor
>  stepping        : 1
>  cpu MHz         : 1312.969
>  cache size      : 64 KB
>  fdiv_bug        : no
>  hlt_bug         : no
>  f00f_bug        : no
>  coma_bug        : no
>  fpu             : yes
>  fpu_exception   : yes
>  cpuid level     : 1
>  wp              : yes
>  flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov
> pat pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow ts
>  bogomips        : 2628.68
>  clflush size    : 32
>
>  while on current mainline PAT and TS (Temperature Sensor) drop from the
> feature flags:
>
>  flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov
> pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow
>
>  With respect to PAT, I guess it's 9307cacad0dfe3749f00303125c6f7f0523e5616,
> "x86: pat cpu feature bit setting for known cpus" but what's this about?
>
>  Did my cpuinfo lie upto this point or shouldn't the flag be cleared? The
> commit message for that change is completely and totally unhelpful.

others like to to whitebox methods, ..., please try attach patch to
see if duron support PAT.

YH

------=_Part_20814_22758030.1210127985006
Content-Type: text/x-patch; name=duron_pat.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ffxax3qu0
Content-Disposition: attachment; filename=duron_pat.patch

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMgYi9hcmNoL3g4Ni9rZXJu
ZWwvY3B1L2NvbW1vbi5jCmluZGV4IGE0MjhmZmMuLjgxNDgzZWMgMTAwNjQ0Ci0tLSBhL2FyY2gv
eDg2L2tlcm5lbC9jcHUvY29tbW9uLmMKKysrIGIvYXJjaC94ODYva2VybmVsL2NwdS9jb21tb24u
YwpAQCAtMzE0LDYgKzMxNCw4IEBAIHN0YXRpYyB2b2lkIF9fY3B1aW5pdCBlYXJseV9nZXRfY2Fw
KHN0cnVjdCBjcHVpbmZvX3g4NiAqYykKIAljYXNlIFg4Nl9WRU5ET1JfQU1EOgogCQlpZiAoYy0+
eDg2ID49IDB4ZiAmJiBjLT54ODYgPD0gMHgxMSkKIAkJCXNldF9jcHVfY2FwKGMsIFg4Nl9GRUFU
VVJFX1BBVCk7CisJCWlmIChjLT54ODYgPT0gNiAmJiBjLT54ODZfbW9kZXMgPT0gNykKKwkJCXNl
dF9jcHVfY2FwKGMsIFg4Nl9GRUFUVVJFX1BBVCk7CiAJCWJyZWFrOwogCWNhc2UgWDg2X1ZFTkRP
Ul9JTlRFTDoKIAkJaWYgKGMtPng4NiA9PSAweEYgfHwgKGMtPng4NiA9PSA2ICYmIGMtPng4Nl9t
b2RlbCA+PSAxNSkpCg==
------=_Part_20814_22758030.1210127985006--
