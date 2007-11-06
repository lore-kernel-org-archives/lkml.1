Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbXKFDMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbXKFDMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 22:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbXKFDMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 22:12:12 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:36238 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741AbXKFDML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 22:12:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=ETod0PpNqNx3SV6gPZaI8UxP6tHWoR/9usgovnKx2OHnczpHBaCH/2goRd5akca/aG+EA/wLjqXVCwJ+Dvz078cL8jQCWC6l5LllTQDTvkzTA4SlGLapHOogFkcYNbvy2ZSf43Q1dOfnfk9IKmkkv6eRatNfCpOuMHqH8uCYwG8=
Message-ID: <a8e1da0711051912r34c6ad68jc420ceb8655407b7@mail.gmail.com>
Date: Tue, 6 Nov 2007 11:12:09 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: [PATCH]bluetooth rfcomm_dev refcount bug fix
Cc: linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
In-Reply-To: <1194274870.4437.8.camel@aeonflux>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_27084_12391945.1194318729620"
References: <20071105045921.GA3556@darkstar.te-china.tietoenator.com>
	 <1194274870.4437.8.camel@aeonflux>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_27084_12391945.1194318729620
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 11/5/07, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Dave,
>
> > In the rfcomm_tty_hangup the rfcomm_dev refcnt should be dropped later.
> >
> > If rfcomm_dev is destructed in tty_hangup function, then the later tty_close function will oops.
>
> your patch removes the complete release on hangup logic. That can't be
> right. I think the problem is with calling tty_vhangup() and then
> decrementing the reference count. In case we call tty_vhangup and we
> have release on hangup we should not delete the device here. What about
> the attached patch? Does it solve it?
>

How about this patch (attached), it works for me as well.

Regards
dave

------=_Part_27084_12391945.1194318729620
Content-Type: application/octet-stream; name=diff.rfcomm.1
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f8numart
Content-Disposition: attachment; filename=diff.rfcomm.1

ZGlmZiAtdXByIGxpbnV4L25ldC9ibHVldG9vdGgvcmZjb21tL3R0eS5jIGxpbnV4Lm5ldy9uZXQv
Ymx1ZXRvb3RoL3JmY29tbS90dHkuYwotLS0gbGludXgvbmV0L2JsdWV0b290aC9yZmNvbW0vdHR5
LmMJMjAwNy0xMS0wNSAxMToyODo0OS4wMDAwMDAwMDAgKzA4MDAKKysrIGxpbnV4Lm5ldy9uZXQv
Ymx1ZXRvb3RoL3JmY29tbS90dHkuYwkyMDA3LTExLTA2IDExOjEzOjAyLjAwMDAwMDAwMCArMDgw
MApAQCAtNDI2LDcgKzQyNiw2IEBAIHN0YXRpYyBpbnQgcmZjb21tX3JlbGVhc2VfZGV2KHZvaWQg
X191c2UKIAkJdHR5X3ZoYW5ndXAoZGV2LT50dHkpOwogCiAJcmZjb21tX2Rldl9kZWwoZGV2KTsK
LQlyZmNvbW1fZGV2X3B1dChkZXYpOwogCXJldHVybiAwOwogfQogCk9ubHkgaW4gbGludXgubmV3
L25ldC9ibHVldG9vdGgvcmZjb21tOiB0dHkuY34K
------=_Part_27084_12391945.1194318729620--
