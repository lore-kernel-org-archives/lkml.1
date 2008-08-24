Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbYHXT3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbYHXT3V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 15:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbYHXT3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 15:29:13 -0400
Received: from po-out-1718.google.com ([72.14.252.152]:34933 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbYHXT3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 15:29:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=UQbWBv/4l2N8jcaWbBBg7+htdelVmAm88qXheQpnGefU6NqLZL6G5pdVKEcHYxMDDV
         fwuCWp3VfmcPjnSch/Xtp9vU3x6i3cgYmATaFia0jMEQq3J+MyrPuKX0xLRMjHEhDmv5
         gBrdnNmJ1lqXLTIOSX+v8BlwmAs9RpwQLfGlc=
Message-ID: <86802c440808241229m16440f68gb8961706473447cb@mail.gmail.com>
Date: Sun, 24 Aug 2008 12:29:11 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <751256.282.qm@web82108.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_38700_28211920.1219606151668"
References: <751256.282.qm@web82108.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_38700_28211920.1219606151668
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, Aug 24, 2008 at 6:05 AM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
>
>
>> > - Is there any chance I can get it into the stable 2.6.26.X updates?
>> > (Who should I ask, or are only developers allowed to lobby for this
>> > sort of thing?)
>>
>> after the patch get into linus tree. Greg will put the patch into 2.6.26.X
>
> OK, thanks a bunch.
>
>
>> > - Are you worried about the potential problems of a quirk-based approach?
>> > What if many more people experience a similar regression once 2.6.26 or
>> > later appears in their distribution?  I'm sure you don't want to have to
>> > write a different quirk for each individual's hardware, and this problem
>> > did not arise with the approach used for resource management in 2.6.25.
>>
>> this patch should be safe.
>>
>> 2.6.26 is fixing one bug about reserving local apic address and that
>> in e820 table.
>> and it reveals one bios bug.
>
> Correction -- it revealed at least two.  See the link I posted earlier in
> this thread:
>
> http://www.uwsg.indiana.edu/hypermail/linux/kernel/0808.2/1807.html
>
> Scroll down to the line that starts with "[blog]" for the link. You can see
> the discussion I had encouraging him to come here to help us troubleshoot
> if you go to that blog and click "Comments".
>
> I only mention this as a warning, in case it could lead to a lot of extra
> problems for you later.  If you're quite sure that everything is OK, then
> all I can do is thank you again and keep my fingers crossed for you and the
> kernel team that nothing bad happens when 2.6.2[67] hit the major distros.

after discussing with Ingo, we have one more generic way to detect the
same situation.

please help to verify the attached patch. ( don't apply previous patch)

YH

------=_Part_38700_28211920.1219606151668
Content-Type: text/x-patch; name=check_res_with_bar.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fka1vylk0
Content-Disposition: attachment; filename=check_res_with_bar.patch

W1BBVENIXSB4ODY6IGNoZWNrIGhwZXQgd2l0aCBCQVIKCmluc2VydCBzb21lIHJlc291cmNlcyB0
byByZXNvdXJjZSB0cmVlIGZvcmNpbHksIHNvIGNvdWxkIGF2b2lkIGtlcm5lbCB1cGRhdGUgdGhl
CnJlc291cmNlcyBpbiBwY2kgZGV2aWNlLgoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWhs
dS5rZXJuZWxAZ21haWwuY29tPgoKLS0tCiBhcmNoL3g4Ni9wY2kvaTM4Ni5jIHwgICA0MyArKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwg
NDMgaW5zZXJ0aW9ucygrKQoKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9wY2kvaTM4Ni5jCj09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L3BjaS9pMzg2LmMKKysrIGxpbnV4
LTIuNi9hcmNoL3g4Ni9wY2kvaTM4Ni5jCkBAIC0zMyw2ICszMyw3IEBACiAjaW5jbHVkZSA8bGlu
dXgvYm9vdG1lbS5oPgogCiAjaW5jbHVkZSA8YXNtL3BhdC5oPgorI2luY2x1ZGUgPGFzbS9ocGV0
Lmg+CiAKICNpbmNsdWRlICJwY2kuaCIKIApAQCAtNzcsNiArNzgsMzAgQEAgcGNpYmlvc19hbGln
bl9yZXNvdXJjZSh2b2lkICpkYXRhLCBzdHJ1YwogfQogRVhQT1JUX1NZTUJPTChwY2liaW9zX2Fs
aWduX3Jlc291cmNlKTsKIAorc3RhdGljIGludCBjaGVja19yZXNfd2l0aF92YWxpZChzdHJ1Y3Qg
cGNpX2RldiAqZGV2LCBzdHJ1Y3QgcmVzb3VyY2UgKnJlcykKK3sKKwl1bnNpZ25lZCBsb25nIGJh
c2U7CisJdW5zaWduZWQgbG9uZyBzaXplOworCisJYmFzZSA9IHJlcy0+c3RhcnQ7CisJc2l6ZSA9
IChyZXMtPnN0YXJ0ID09IDAgJiYgcmVzLT5lbmQgPT0gcmVzLT5zdGFydCkgPyAwIDoKKwkJIChy
ZXMtPmVuZCAtIHJlcy0+c3RhcnQgKyAxKTsKKworCWlmICghYmFzZSB8fCAhc2l6ZSkKKwkJcmV0
dXJuIDA7CisKKyNpZmRlZiBDT05GSUdfSFBFVF9USU1FUgorCS8qIGZvciBocGV0ICovCisJaWYg
KGJhc2UgPT0gaHBldF9hZGRyZXNzICYmIChyZXMtPmZsYWdzICYgSU9SRVNPVVJDRV9NRU0pKSB7
CisJCWRldl9pbmZvKCZkZXYtPmRldiwgIkJBUiBoYXMgSFBFVCBhdCAlMDhseC0lMDhseFxuIiwK
KwkJCQkgYmFzZSwgYmFzZSArIHNpemUgLSAxKTsKKwkJcmV0dXJuIDE7CisJfQorI2VuZGlmCisK
KwlyZXR1cm4gMDsKK30KKwogLyoKICAqICBIYW5kbGUgcmVzb3VyY2VzIG9mIFBDSSBkZXZpY2Vz
LiAgSWYgdGhlIHdvcmxkIHdlcmUgcGVyZmVjdCwgd2UgY291bGQKICAqICBqdXN0IGFsbG9jYXRl
IGFsbCB0aGUgcmVzb3VyY2UgcmVnaW9ucyBhbmQgZG8gbm90aGluZyBtb3JlLiAgSXQgaXNuJ3Qu
CkBAIC0xMjgsNiArMTUzLDI0IEBAIHN0YXRpYyB2b2lkIF9faW5pdCBwY2liaW9zX2FsbG9jYXRl
X2J1c18KIAkJCQlwciA9IHBjaV9maW5kX3BhcmVudF9yZXNvdXJjZShkZXYsIHIpOwogCQkJCWlm
ICghci0+c3RhcnQgfHwgIXByIHx8CiAJCQkJICAgIHJlcXVlc3RfcmVzb3VyY2UocHIsIHIpIDwg
MCkgeworCQkJCQlpZiAoY2hlY2tfcmVzX3dpdGhfdmFsaWQoZGV2LCByKSkgeworCQkJCQkJc3Ry
dWN0IHJlc291cmNlICpyb290ID0gTlVMTDsKKworCQkJCQkJLyoKKwkJCQkJCSAqIGZvcmNpYmx5
IGluc2VydCBpdCBpbnRvIHRoZQorCQkJCQkJICogcmVzb3VyY2UgdHJlZQorCQkJCQkJICovCisJ
CQkJCQlpZiAoci0+ZmxhZ3MgJiBJT1JFU09VUkNFX01FTSkKKwkJCQkJCQlyb290ID0gJmlvbWVt
X3Jlc291cmNlOworCQkJCQkJZWxzZSBpZiAoci0+ZmxhZ3MgJiBJT1JFU09VUkNFX0lPKQorCQkJ
CQkJCXJvb3QgPSAmaW9wb3J0X3Jlc291cmNlOworCisJCQkJCQlpZiAocm9vdCkgeworCQkJCQkJ
CWluc2VydF9yZXNvdXJjZShyb290LCByKTsKKwkJCQkJCX0KKwkJCQkJCWNvbnRpbnVlOworCQkJ
CQl9CisKIAkJCQkJZGV2X2VycigmZGV2LT5kZXYsICJCQVIgJWQ6IGNhbid0ICIKIAkJCQkJCSJh
bGxvY2F0ZSByZXNvdXJjZVxuIiwgaWR4KTsKIAkJCQkJLyoK
------=_Part_38700_28211920.1219606151668--
