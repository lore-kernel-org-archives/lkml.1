Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbYHXWsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbYHXWsR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 18:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbYHXWsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 18:48:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:50056 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbYHXWsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 18:48:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=nOiJ/wsTtWFkMtg6nJRMsvwVYX3F3WxwqLBT1R4gfturEqjiGnE0JL6kY6Ne7Pzll2
         nLzsT+XdjYO3GDZzbUtgos49LUZfaVcy8Z3B1UPbcRFx5G94dxxgiZatAqDRbrajNpsU
         y0jS9pZC7hciWsmbxuZJou3hmO43T9z4oRAJs=
Message-ID: <86802c440808241548l3af0810egfcd424b0b6c6a9cd@mail.gmail.com>
Date: Sun, 24 Aug 2008 15:48:02 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440808241229m16440f68gb8961706473447cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_39989_30471844.1219618082956"
References: <751256.282.qm@web82108.mail.mud.yahoo.com>
	 <86802c440808241229m16440f68gb8961706473447cb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_39989_30471844.1219618082956
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, Aug 24, 2008 at 12:29 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Sun, Aug 24, 2008 at 6:05 AM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
>>
>>
>>> > - Is there any chance I can get it into the stable 2.6.26.X updates?
>>> > (Who should I ask, or are only developers allowed to lobby for this
>>> > sort of thing?)
>>>
>>> after the patch get into linus tree. Greg will put the patch into 2.6.26.X
>>
>> OK, thanks a bunch.
>>
>>
>>> > - Are you worried about the potential problems of a quirk-based approach?
>>> > What if many more people experience a similar regression once 2.6.26 or
>>> > later appears in their distribution?  I'm sure you don't want to have to
>>> > write a different quirk for each individual's hardware, and this problem
>>> > did not arise with the approach used for resource management in 2.6.25.
>>>
>>> this patch should be safe.
>>>
>>> 2.6.26 is fixing one bug about reserving local apic address and that
>>> in e820 table.
>>> and it reveals one bios bug.
>>
>> Correction -- it revealed at least two.  See the link I posted earlier in
>> this thread:
>>
>> http://www.uwsg.indiana.edu/hypermail/linux/kernel/0808.2/1807.html
>>
>> Scroll down to the line that starts with "[blog]" for the link. You can see
>> the discussion I had encouraging him to come here to help us troubleshoot
>> if you go to that blog and click "Comments".
>>
>> I only mention this as a warning, in case it could lead to a lot of extra
>> problems for you later.  If you're quite sure that everything is OK, then
>> all I can do is thank you again and keep my fingers crossed for you and the
>> kernel team that nothing bad happens when 2.6.2[67] hit the major distros.
>
> after discussing with Ingo, we have one more generic way to detect the
> same situation.
>
> please help to verify the attached patch. ( don't apply previous patch)
>

and please test attached patch too. ( could test it without two patches)

YH

------=_Part_39989_30471844.1219618082956
Content-Type: text/x-patch; name=only_put_e820_ram_in_res_tree.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fka92h0p1
Content-Disposition: attachment;
 filename=only_put_e820_ram_in_res_tree.patch

RnJvbTogWWluZ2hhaSBMdSA8eWhsdS5rZXJuZWxAZ21haWwuY29tPgpTdWJqZWN0OiBbUEFUQ0hd
IHg4Njogb25seSBwdXQgZTgyMCByYW0gZW50cmllcyBpbiByZXNvdXJjZSB0cmVlCgptYXkgbmVl
ZCB1c2VyIHRvIGhhdmUgbmV3IGtleGVjIHRvb2xzIHRoYXQgY291bGQgY3JlYXRlIGU4MjAgdGFi
bGUKZnJvbSAvc3lzL2Zpcm13YXJlL21lbW1hcCBpbnN0ZWFkIG9mIC9wcm9jL2lvbWVtIGZvciBz
ZWNvbmQga2VybmVsCgpTaWduZWQtb2ZmLWJ5OiBZaW5naGFpIEx1IDx5aGx1Lmtlcm5lbEBnbWFp
bC5jb20+CkNjOiBCZXJuaGFyZCBXYWxsZSA8YndhbGxlQHN1c2UuZGU+CkNjOiBWaXZlayBHb3lh
bCA8dmdveWFsQHJlZGhhdC5jb20+CkNjOiAiRXJpYyBXLiBCaWVkZXJtYW4iIDxlYmllZGVybUB4
bWlzc2lvbi5jb20+CgpJbmRleDogbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9lODIwLmMKPT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYva2VybmVsL2U4MjAuYworKysgbGlu
dXgtMi42L2FyY2gveDg2L2tlcm5lbC9lODIwLmMKQEAgLTEyNzksNiArMTI3OSwxMCBAQCB2b2lk
IF9faW5pdCBlODIwX3Jlc2VydmVfcmVzb3VyY2VzKHZvaWQpCiAKIAlyZXMgPSBhbGxvY19ib290
bWVtX2xvdyhzaXplb2Yoc3RydWN0IHJlc291cmNlKSAqIGU4MjAubnJfbWFwKTsKIAlmb3IgKGkg
PSAwOyBpIDwgZTgyMC5ucl9tYXA7IGkrKykgeworCQlpZiAoZTgyMC5tYXBbaV0udHlwZSAhPSBF
ODIwX1JBTSkgeworCQkJcmVzKys7CisJCQljb250aW51ZTsKKwkJfQogCQllbmQgPSBlODIwLm1h
cFtpXS5hZGRyICsgZTgyMC5tYXBbaV0uc2l6ZSAtIDE7CiAjaWZuZGVmIENPTkZJR19SRVNPVVJD
RVNfNjRCSVQKIAkJaWYgKGVuZCA+IDB4MTAwMDAwMDAwVUxMKSB7Cg==
------=_Part_39989_30471844.1219618082956--
