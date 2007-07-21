Return-Path: <linux-kernel-owner+w=401wt.eu-S936224AbXGUIgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936224AbXGUIgw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 04:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbXGUIgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 04:36:44 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:37286 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbXGUIgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 04:36:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=aQXVl8m0QXbeH+xF6xE8vMbpp2sf3P6AcP/8B1yBW/TC/FZbgIYJ/zgg+ecbOlyZUFyRsiGAm25eFXHkCjiuk0T+OZDsEHn8z9VOzl1EwLHRUFYGjjkL6SNhKFk2wYr16kCTs6Jl6OTRv7d8oQj9wRekGC6iq3mafS+geAioxO4=
Message-ID: <a781481a0707210136l272fc4fauaf14afce4178d9e4@mail.gmail.com>
Date: Sat, 21 Jul 2007 14:06:41 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [broken-out-2007-07-20-00-22] kernel bug at kernel/params:570
Cc: "Greg KH" <gregkh@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       rdunlap@xenotime.net, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <46A1BD31.4000804@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_125621_76843.1185007001566"
References: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com>
	 <a781481a0707201643l17ea92fajfbc256a7a16a802f@mail.gmail.com>
	 <a781481a0707201703h6318fe65td4c5c6f57bb7eb24@mail.gmail.com>
	 <6bffcb0e0707201728u6deeccd1j453ff89d0767dccc@mail.gmail.com>
	 <20070721010257.GA9561@suse.de>
	 <20070720183733.c53b511b.akpm@linux-foundation.org>
	 <20070721014419.GA10761@suse.de>
	 <a781481a0707202021r977ae5fg9655dd2881836f13@mail.gmail.com>
	 <a781481a0707202057q23a0ea6by97ee9b40e9fc5a0b@mail.gmail.com>
	 <46A1BD31.4000804@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_125621_76843.1185007001566
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 7/21/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> Satyam Sharma pisze:
> > [...]
> > Gargh! My system obviously cannot boot without libata. Guess it's
> > time to go through git log and see how to fix that build breakage
> > myself ...
> >
> > Michal, how did you even manage to build / boot this kernel!
>
> I commented origin.patch and mm.patch in series file, reverted xfs patches,
> fixed libata build, deselected unionfs.
>
> Here is a patch for libata
>
> --- linux-work3-clean/drivers/ata/libata-core.c 2007-07-20 16:53:26.000000000 +0200
> +++ linux-work3/drivers/ata/libata-core.c       2007-07-20 17:26:30.000000000 +0200
> @@ -2036,7 +2036,7 @@ int ata_dev_configure(struct ata_device
>                 dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
>                                          dev->max_sectors);
>
> -       if (ata_device_blacklisted(dev) & ATA_HORKAGE_ALPM) {
> +       if (ata_dev_blacklisted(dev) & ATA_HORKAGE_ALPM) {
>                 dev->horkage |= ATA_HORKAGE_ALPM;
>
>                 /* reset link pm_policy for this port to no pm */


And to think I went through all those hoops just to avoid *this* ... :-(
Anyway, please apply the attached patch and let's verify if we're both
actually bit by the same bug. A screenshot of my case is available at:

http://www.cse.iitk.ac.in/users/ssatyam/mtrr.show-bug.jpg

[ excuse the quality, it's not a digicam, but a cellphone-cam ]

Satyam

------=_Part_125621_76843.1185007001566
Content-Type: text/x-patch; name=test.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f4duazds
Content-Disposition: attachment; filename="test.patch"

ZGlmZiAtLWdpdCBhL2tlcm5lbC9wYXJhbXMuYyBiL2tlcm5lbC9wYXJhbXMuYwppbmRleCBlZmZi
YWFlLi41NjU2Y2NmIDEwMDY0NAotLS0gYS9rZXJuZWwvcGFyYW1zLmMKKysrIGIva2VybmVsL3Bh
cmFtcy5jCkBAIC01NjcsNyArNTY3LDExIEBAIHN0YXRpYyB2b2lkIF9faW5pdCBrZXJuZWxfcGFy
YW1fc3lzZnNfc2V0dXAoY29uc3QgY2hhciAqbmFtZSwKIAlrb2JqZWN0X3NldF9uYW1lKCZtay0+
a29iaiwgbmFtZSk7CiAJa29iamVjdF9pbml0KCZtay0+a29iaik7CiAJcmV0ID0ga29iamVjdF9h
ZGQoJm1rLT5rb2JqKTsKLQlCVUdfT04ocmV0IDwgMCk7CisJaWYgKHJldCkgeworCQlwcmludGYo
In5+fn5+IC4lcy4lZC4lcy4gfn5+fn5cbiIsIG5hbWUsIHJldCwga3BhcmFtLT5uYW1lKTsKKwkJ
Zm9yICg7OykKKwkJCWNwdV9yZWxheCgpOworCX0KIAlwYXJhbV9zeXNmc19zZXR1cChtaywga3Bh
cmFtLCBudW1fcGFyYW1zLCBuYW1lX3NraXApOwogCWtvYmplY3RfdWV2ZW50KCZtay0+a29iaiwg
S09CSl9BREQpOwogfQo=
------=_Part_125621_76843.1185007001566--
