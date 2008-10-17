Return-Path: <linux-kernel-owner+w=401wt.eu-S1757075AbYJQWRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbYJQWRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 18:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYJQWRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 18:17:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:40146 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbYJQWRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 18:17:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=NNPkBbz60CRoH97WS1KtIZaIPctSTzvChnbtXo8U+qcG5In9YprDLLFMV29hxgJZNC
         kvT+EP75BWuNyEZojpjVWWQIaeyyRGWyld0ax9eJAw8Fwij2cr32qqafkg97C1jJ0NN9
         mpsOUE+vyhQIx9ic7SlMiaKEwVdps8PbDOomo=
Message-ID: <35f686220810171517y6632b4b2p3d251d43753eb3d6@mail.gmail.com>
Date: Fri, 17 Oct 2008 15:17:39 -0700
From: "Alok Kataria" <alokkataria1@gmail.com>
To: "Antipov Dmitry" <dmantipov@yandex.ru>
Subject: Re: 2.6.27: 0 MHz CPU and wrong system time on AMD Geode system
Cc: linux-kernel@vger.kernel.org, "Jordan Crouse" <jordan.crouse@amd.com>,
       akataria@vmware.com
In-Reply-To: <673951224218937@webmail87.yandex.ru>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_39216_11925978.1224281859773"
References: <673951224218937@webmail87.yandex.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_39216_11925978.1224281859773
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Oct 16, 2008 at 9:48 PM, Antipov Dmitry <dmantipov@yandex.ru> wrote:
> Jordan Crouse wrote:
>
>> Could you try a 2.6.26 kernel? That will confirm that this is a new
>> addition to 2.6.27.
>
> Both 2.6.26 and 2.6.26.6 looks good (with CONFIG_GEODE_MFGPT_TIMER=y).

Can you try the attached debug patch, it puts a printk message and
will let us know what exaclty is failing during the calibration
process.
There were some major changes in the 2.6.27 cycle related to tsc calibration.
Apart from the unification for 32 and 64bit, some checks were added in
the code to make the calibration process more robust, maybe this
specific machine is more prone to SMI's than other, as a result the
checks are a little to harsh for this one.

Along with the dmesg with this patch, could you also let us know how
much is the frequency that the (2.6.26) kernel calibrates and what the
actual freuqency is on that box ?

Thanks,
Alok
>
> Dmitry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

------=_Part_39216_11925978.1224281859773
Content-Type: text/x-patch; name=debug_tsc_calibrate.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fmfdq6gc0
Content-Disposition: attachment; filename=debug_tsc_calibrate.patch

SW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvdHNjLmMKPT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGlu
dXgtMi42Lm9yaWcvYXJjaC94ODYva2VybmVsL3RzYy5jCTIwMDgtMTAtMTcgMTQ6NTY6MjMuMDAw
MDAwMDAwIC0wNzAwCisrKyBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL3RzYy5jCTIwMDgtMTAt
MTcgMTU6MDE6MzguMDAwMDAwMDAwIC0wNzAwCkBAIC0xNjMsNiArMTYzLDggQEAKIAkJcGl0Y250
Kys7CiAJfQogCisJcHJpbnRrKCJERUJVRzogcGl0Y250ICVkLCB0c2NtaW4gJWx1LCB0c2NtYXgg
JWx1XG4iLAorCQkJCXBpdGNudCwgdHNjbWluLCB0c2NtYXgpOwogCS8qCiAJICogU2FuaXR5IGNo
ZWNrczoKIAkgKgo=
------=_Part_39216_11925978.1224281859773--
