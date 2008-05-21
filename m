Return-Path: <linux-kernel-owner+w=401wt.eu-S937380AbYEUUgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937380AbYEUUgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937298AbYEUUgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:36:18 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:44509 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936423AbYEUUgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:36:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=lQkj1258FPA7vUJ45KvsxWl0eDvkbo75E3Rqzkyw0aU/QMrcKhVf/yFubGs86W0ZJrPLL4BqxYerOnCk1F4QSlkLRfM0rRo3XC+jrnmufRlLbZwAPr+4OcDy0VEmoVXjelxmajnsEUQNkDOzHmUJeJQJo15febra5Yi86vad5NY=
Message-ID: <86802c440805211335q27334ba1g32a43fb1c0498b9b@mail.gmail.com>
Date: Wed, 21 May 2008 13:35:40 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: Suspected regression in "x86: extend e820 ealy_res support 32bit"
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <483467CD.90401@goop.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_8946_8549749.1211402140416"
References: <483467CD.90401@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_8946_8549749.1211402140416
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, May 21, 2008 at 11:19 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> I'm seeing a crash in current x86.git tip/auto-latest when booting under
> Xen.  The crash is rather early, but it's in __alloc_bootmem_core() in the
> final memset clear.  Apparently the allocator is returning a bad page.
>
> This points to changes in the setup of the bootmem allocator, and the
> changes "x86: extend e820 ealy_res support 32bit" make to
> arch/x86/kernel/setup_32.c:setup_bootmem_allocator() looks like the most
> likely suspect.  Unfortunately its a rather large patch which is not easy to
> revert, so I haven't actually confirmed this yet.


thanks. please check the attached patch

YH

------=_Part_8946_8549749.1211402140416
Content-Type: text/x-patch; name=bootmap_32_fix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fgidjjf50
Content-Disposition: attachment; filename=bootmap_32_fix.patch

W1BBVENIXSB4ODY6IGJvb3RtYXAgc2l6ZSBmaXggZm9yIDMyIGJpdAoKSmVyZW15IEZpdHpoYXJk
aW5nZSBmb3VuZAp4ODY6IGV4dGVuZCBlODIwIGVhbHlfcmVzIHN1cHBvcnQgMzJiaXQKY2F1c2Ug
cmVncmVzc2lvbi4uLgoKaW4gc2V0dXBfYm9vdG1lbV9hbGxvY2F0b3IKClNpZ25lZC1vZmYtYnk6
IFlpbmdoYWkgTHUgPHlobHUua2VybmVsQGdtYWlsLmNvbT4KCmRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9rZXJuZWwvc2V0dXBfMzIuYyBiL2FyY2gveDg2L2tlcm5lbC9zZXR1cF8zMi5jCmluZGV4IGYz
OGQ4NDAuLjkzOGM3YjMgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9zZXR1cF8zMi5jCisr
KyBiL2FyY2gveDg2L2tlcm5lbC9zZXR1cF8zMi5jCkBAIC01NjYsMTcgKzU2NiwyMiBAQCBzdGF0
aWMgdm9pZCBfX2luaXQgcmVsb2NhdGVfaW5pdHJkKHZvaWQpCiAKIHZvaWQgX19pbml0IHNldHVw
X2Jvb3RtZW1fYWxsb2NhdG9yKHZvaWQpCiB7CisJdW5zaWduZWQgbG9uZyBib290bWFwX3BhZ2Vz
OwogCXVuc2lnbmVkIGxvbmcgYm9vdG1hcF9zaXplLCBib290bWFwOwogCS8qCiAJICogSW5pdGlh
bGl6ZSB0aGUgYm9vdC10aW1lIGFsbG9jYXRvciAod2l0aCBsb3cgbWVtb3J5IG9ubHkpOgogCSAq
LwotCWJvb3RtYXBfc2l6ZSA9IGJvb3RtZW1fYm9vdG1hcF9wYWdlcyhtYXhfbG93X3Bmbik8PFBB
R0VfU0hJRlQ7CisJYm9vdG1hcF9wYWdlcyA9IGJvb3RtZW1fYm9vdG1hcF9wYWdlcyhtYXhfbG93
X3Bmbik8PFBBR0VfU0hJRlQ7CiAJYm9vdG1hcCA9IGZpbmRfZTgyMF9hcmVhKG1pbl9sb3dfcGZu
PDxQQUdFX1NISUZULAotCQkJCSBtYXhfbG93X3Bmbjw8UEFHRV9TSElGVCwgYm9vdG1hcF9zaXpl
LAorCQkJCSBtYXhfbG93X3Bmbjw8UEFHRV9TSElGVCwKKwkJCQkgYm9vdG1hcF9wYWdlczw8UEFH
RV9TSElGVCwKIAkJCQkgUEFHRV9TSVpFKTsKIAlpZiAoYm9vdG1hcCA9PSAtMUwpCiAJCXBhbmlj
KCJDYW5ub3QgZmluZCBib290bWVtIG1hcCBvZiBzaXplICVsZFxuIiwgYm9vdG1hcF9zaXplKTsK
IAlib290bWFwX3NpemUgPSBpbml0X2Jvb3RtZW0oYm9vdG1hcCA+PiBQQUdFX1NISUZULCBtYXhf
bG93X3Bmbik7CisJcHJpbnRrKEtFUk5fSU5GTyAiICBib290bWFwIFslMDE2bHggLSAgJTAxNmx4
XSBwYWdlcyAlbHhcbiIsCisJCSBib290bWFwLCBib290bWFwICsgYm9vdG1hcF9zaXplIC0gMSwK
KwkJIGJvb3RtYXBfcGFnZXMpOwogCXJlZ2lzdGVyX2Jvb3RtZW1fbG93X3BhZ2VzKG1heF9sb3df
cGZuKTsKIAllYXJseV9yZXNfdG9fYm9vdG1lbSgwLCBtYXhfbG93X3Bmbjw8UEFHRV9TSElGVCk7
CiAJcmVzZXJ2ZV9ib290bWVtKGJvb3RtYXAsIGJvb3RtYXBfc2l6ZSwgQk9PVE1FTV9ERUZBVUxU
KTsK
------=_Part_8946_8549749.1211402140416--
