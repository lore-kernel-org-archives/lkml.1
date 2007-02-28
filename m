Return-Path: <linux-kernel-owner+w=401wt.eu-S1751497AbXB1EMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbXB1EMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 23:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbXB1EMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 23:12:30 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:49368 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbXB1EM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 23:12:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=QuVQPwfZH3AwHVsDGGC/2tiNNzh5hvG20Uo3zwO65c8uW3/RVY9LNxFJwbuILLZXDph/MnjSA5D3gkQg1VNEDWq+4l905OwyNFcsPXqfnAIBovnqYpVgwrCg7RvA3W7wdQ4x23hIJN2G7K2rkKEkpuiWvpfZCqgTS4puFVXRVSg=
Message-ID: <cc723f590702272012qe913bcbi2a222e6e0aa09efb@mail.gmail.com>
Date: Wed, 28 Feb 2007 09:42:27 +0530
From: "Aneesh Kumar" <aneesh.kumar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] init_new_context: Use the passed task argument
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070227122644.d2616dc3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_20681_6956553.1172635947654"
References: <11722452363488-git-send-email-aneesh.kumar@gmail.com>
	 <11722452452225-git-send-email-aneesh.kumar@gmail.com>
	 <20070227122644.d2616dc3.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_20681_6956553.1172635947654
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 2/28/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Fri, 23 Feb 2007 21:10:36 +0530 "Aneesh Kumar K.V" <aneesh.kumar@gmail.com> wrote:
> > From: Aneesh Kumar K.V <aneesh.kumar@gmail.com>
> >
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@gmail.com>
> > ---
> >  arch/i386/kernel/ldt.c   |    2 +-
> >  arch/x86_64/kernel/ldt.c |    2 +-
> >  kernel/fork.c            |    2 +-
> >  3 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/i386/kernel/ldt.c b/arch/i386/kernel/ldt.c
> > index b410e5f..925354c 100644
> > --- a/arch/i386/kernel/ldt.c
> > +++ b/arch/i386/kernel/ldt.c
> > @@ -97,7 +97,7 @@ int init_new_context(struct task_struct *tsk, struct mm_struct *mm)
> >
> >       init_MUTEX(&mm->context.sem);
> >       mm->context.size = 0;
> > -     old_mm = current->mm;
> > +     old_mm = tsk->mm;
> >       if (old_mm && old_mm->context.size > 0) {
> >               down(&old_mm->context.sem);
> >               retval = copy_ldt(&mm->context, &old_mm->context);
> > diff --git a/arch/x86_64/kernel/ldt.c b/arch/x86_64/kernel/ldt.c
> > index d7e5d0c..16ae79d 100644
> > --- a/arch/x86_64/kernel/ldt.c
> > +++ b/arch/x86_64/kernel/ldt.c
> > @@ -101,7 +101,7 @@ int init_new_context(struct task_struct *tsk, struct mm_struct *mm)
> >
> >       init_MUTEX(&mm->context.sem);
> >       mm->context.size = 0;
> > -     old_mm = current->mm;
> > +     old_mm = tsk->mm;
> >       if (old_mm && old_mm->context.size > 0) {
> >               down(&old_mm->context.sem);
> >               retval = copy_ldt(&mm->context, &old_mm->context);
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index d154cc7..2423d83 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -496,7 +496,7 @@ static struct mm_struct *dup_mm(struct task_struct *tsk)
> >       if (!mm_init(mm))
> >               goto fail_nomem;
> >
> > -     if (init_new_context(tsk, mm))
> > +     if (init_new_context(current, mm))
> >               goto fail_nocontext;
>
> This last change makes the comment over dup_mm() wrong.  It also generally
> makes dup_mm() less useful, although that migt be OK.  It also makes the
> argument to dup_mm() unused and potentially removable.
>


How about the change as below

------=_Part_20681_6956553.1172635947654
Content-Type: text/x-patch; name=fork.diff; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_eyp95grl
Content-Disposition: attachment; filename="fork.diff"

ZGlmZiAtLWdpdCBhL2tlcm5lbC9mb3JrLmMgYi9rZXJuZWwvZm9yay5jCmluZGV4IDI0MjNkODMu
LjIxODRlZjUgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9mb3JrLmMKKysrIGIva2VybmVsL2ZvcmsuYwpA
QCAtNDc3LDcgKzQ3Nyw3IEBAIHZvaWQgbW1fcmVsZWFzZShzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRz
aywgc3RydWN0IG1tX3N0cnVjdCAqbW0pCiAgKi8KIHN0YXRpYyBzdHJ1Y3QgbW1fc3RydWN0ICpk
dXBfbW0oc3RydWN0IHRhc2tfc3RydWN0ICp0c2spCiB7Ci0Jc3RydWN0IG1tX3N0cnVjdCAqbW0s
ICpvbGRtbSA9IGN1cnJlbnQtPm1tOworCXN0cnVjdCBtbV9zdHJ1Y3QgKm1tLCAqb2xkbW0gPSB0
c2stPm1tOwogCWludCBlcnI7CiAKIAlpZiAoIW9sZG1tKQpAQCAtNDk2LDcgKzQ5Niw3IEBAIHN0
YXRpYyBzdHJ1Y3QgbW1fc3RydWN0ICpkdXBfbW0oc3RydWN0IHRhc2tfc3RydWN0ICp0c2spCiAJ
aWYgKCFtbV9pbml0KG1tKSkKIAkJZ290byBmYWlsX25vbWVtOwogCi0JaWYgKGluaXRfbmV3X2Nv
bnRleHQoY3VycmVudCwgbW0pKQorCWlmIChpbml0X25ld19jb250ZXh0KHRzaywgbW0pKQogCQln
b3RvIGZhaWxfbm9jb250ZXh0OwogCiAJZXJyID0gZHVwX21tYXAobW0sIG9sZG1tKTsKQEAgLTU1
MSw3ICs1NTEsNyBAQCBzdGF0aWMgaW50IGNvcHlfbW0odW5zaWduZWQgbG9uZyBjbG9uZV9mbGFn
cywgc3RydWN0IHRhc2tfc3RydWN0ICogdHNrKQogCX0KIAogCXJldHZhbCA9IC1FTk9NRU07Ci0J
bW0gPSBkdXBfbW0odHNrKTsKKwltbSA9IGR1cF9tbShjdXJyZW50KTsKIAlpZiAoIW1tKQogCQln
b3RvIGZhaWxfbm9tZW07CiAK
------=_Part_20681_6956553.1172635947654--
