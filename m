Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbZAJXFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbZAJXFT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 18:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbZAJXFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 18:05:00 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:13915 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbZAJXE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 18:04:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=FpuTrzorzyN+R6goE/fMmSTmmBLydgShAHL7lqpu1f6hV4LSWq4Bwpby5TqeXyeYfp
         jqeZ5aFV5IRumMMf+UTL4r6iNFjw//t01Ho+5frU6yUOhmqrORowYY70qrKs7qJDvHxM
         L6UOjgCXP/hBFqzBSm3bFni4L5Xmj+4kefCg4=
Message-ID: <21d7e9970901101504w2c21ca22t9106770c4ada696c@mail.gmail.com>
Date: Sun, 11 Jan 2009 09:04:58 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Richard Purdie" <rpurdie@linux.intel.com>
Subject: Re: [git pull] drm
Cc: "Dave Airlie" <airlied@linux.ie>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <1231581491.5330.8.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_116601_13147409.1231628698092"
References: <alpine.DEB.2.00.0812290819020.20427@skynet.skynet.ie>
	 <1231513655.5317.30.camel@dax.rpnet.com>
	 <1231524232.5317.43.camel@dax.rpnet.com>
	 <1231550011.5317.72.camel@dax.rpnet.com>
	 <21d7e9970901091804x61e2ba3cofd37d536df2d48b3@mail.gmail.com>
	 <1231581491.5330.8.camel@dax.rpnet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_116601_13147409.1231628698092
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, Jan 10, 2009 at 7:58 PM, Richard Purdie <rpurdie@linux.intel.com> wrote:
>
> On Sat, 2009-01-10 at 12:04 +1000, Dave Airlie wrote:
>> On Sat, Jan 10, 2009 at 11:13 AM, Richard Purdie
>> <rpurdie@linux.intel.com> wrote:
>> > On Fri, 2009-01-09 at 18:03 +0000, Richard Purdie wrote:
>> >> On Fri, 2009-01-09 at 15:07 +0000, Richard Purdie wrote:
>> >> > I just updated to the latest kernel from git to test some other patches
>> >> > and after logging into GDM the X server hangs before launching the
>> >> > desktop (it appears to be trying to run glxinfo) on my Thinkpad T61
>> >> > (i915 graphics). Bisection shows this happens after applying this
>> >> > commit:
>> >> >
>> >> > On Mon, 2008-12-29 at 08:32 +0000, Dave Airlie wrote:
>> >> > > commit 7c1c2871a6a3a114853ec6836e9035ac1c0c7f7a
>> >> > > Author: Dave Airlie <airlied@redhat.com>
>> >> > > Date:   Fri Nov 28 14:22:24 2008 +1000
>> >
>> > The patch below gets my system working again with the latest kernels.
>> > Was dropping the drm_addmap() call for i915 intentional or not?
>>
>> Yes, so now we need to find out what happens in your userspace, when
>> it hangs is the machine dead?
>>
>> or can you ssh in? any oops in the logs? can you get a sysrq-t
>> backtrace for X.org and glxinfo?
>
> The machine's keyboard and console switching is dead and the login in
> process drops the wifi but I think I can get in through ssh over
> ethernet. The power button does make it shutdown cleanly and there is no
> oops. I'll try and get backtraces later, probably tonight.
>
> I have a question though, where in the i915 driver is
> master_priv->sarea_priv assigned a value? or master_priv->sarea for that
> matter? As far as I can tell those pointers are never assigned values?
> Is there a drm_getsarea() call missing?
>
> Perhaps my patch fixes things since sarea and sarea_priv are given a
> value?
>

Does the attached patch work?

Somehow this code was tested on DRI2 which needs no sarea, and we missed the bit
to setup the DRI1 sarea, this patch should dtrt.

Thanks for reporting/tracking this down..

Dave.
> Cheers,
>
> Richard
>
>
>

------=_Part_116601_13147409.1231628698092
Content-Type: application/octet-stream;
 name=0001-drm-i915-setup-sarea-properly-in-master_priv.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fpsvvtzo0
Content-Disposition: attachment;
 filename=0001-drm-i915-setup-sarea-properly-in-master_priv.patch

RnJvbSBiNmY1NjhkNmFlNzA4NjJmZGU1NDExODc0MWE4ZTMwNjBhYmU0MjVjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZlIEFpcmxpZSA8YWlybGllZEBsaW51eC5pZT4KRGF0ZTog
U3VuLCAxMSBKYW4gMjAwOSAwOTowMzo0OSArMTAwMApTdWJqZWN0OiBbUEFUQ0hdIGRybS9pOTE1
OiBzZXR1cCBzYXJlYSBwcm9wZXJseSBpbiBtYXN0ZXJfcHJpdgoKSWYgd2UgYXJlIHJ1bm5pbmcg
RFJJMSB1c2Vyc3BhY2UsIHdlIHJlYWxseSBuZWVkIHRvIHNldCB0aGUgc2FyZWEgdXAgcHJvcGVy
bHkuCgpTaWduZWQtb2ZmLWJ5OiBEYXZlIEFpcmxpZSA8YWlybGllZEByZWRoYXQuY29tPgotLS0K
IGRyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfZG1hLmMgfCAgICA4ICsrKysrKysrCiAxIGZpbGVz
IGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9k
cml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X2RtYS5jIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkx
NV9kbWEuYwppbmRleCA2MmE0YmY3Li5mYmVlMmQ4IDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9k
cm0vaTkxNS9pOTE1X2RtYS5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfZG1hLmMK
QEAgLTE3Nyw2ICsxNzcsMTQgQEAgc3RhdGljIGludCBpOTE1X2luaXRpYWxpemUoc3RydWN0IGRy
bV9kZXZpY2UgKiBkZXYsIGRybV9pOTE1X2luaXRfdCAqIGluaXQpCiAJZHJtX2k5MTVfcHJpdmF0
ZV90ICpkZXZfcHJpdiA9IGRldi0+ZGV2X3ByaXZhdGU7CiAJc3RydWN0IGRybV9pOTE1X21hc3Rl
cl9wcml2YXRlICptYXN0ZXJfcHJpdiA9IGRldi0+cHJpbWFyeS0+bWFzdGVyLT5kcml2ZXJfcHJp
djsKIAorCW1hc3Rlcl9wcml2LT5zYXJlYSA9IGRybV9nZXRzYXJlYShkZXYpOworCWlmIChtYXN0
ZXJfcHJpdi0+c2FyZWEpIHsKKwkJbWFzdGVyX3ByaXYtPnNhcmVhX3ByaXYgPSAoZHJtX2k5MTVf
c2FyZWFfdCAqKQorCQkJKCh1OCAqKW1hc3Rlcl9wcml2LT5zYXJlYS0+aGFuZGxlICsgaW5pdC0+
c2FyZWFfcHJpdi0+b2Zmc2V0KTsKKwl9IGVsc2UgeworCQlEUk1fREVCVUcoInNhcmVhIG5vdCBm
b3VuZCBhc3N1bWluZyBEUkkyIHVzZXJzcGFjZVxuIik7CisJfQorCiAJaWYgKGluaXQtPnJpbmdf
c2l6ZSAhPSAwKSB7CiAJCWlmIChkZXZfcHJpdi0+cmluZy5yaW5nX29iaiAhPSBOVUxMKSB7CiAJ
CQlpOTE1X2RtYV9jbGVhbnVwKGRldik7Ci0tIAoxLjUuNS4xCgo=
------=_Part_116601_13147409.1231628698092--
