Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbYCDBCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbYCDBCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 20:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbYCDBBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 20:01:54 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:55960 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbYCDBBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 20:01:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=SUolaSOVuMlRlnDzW9DOVQxkV5IaYozckGsGLeApVbQG57ysGiTo5UlpyRqrWC1MrByt42sEizooQ1p5508NqabBq4oUP1xi/eJBy0gzFy4AsO/zE5U2Hywz09Tm/QwpWUKpDI/j1DkXyp+7/pstyD6DTmA/o+uaLwukfzz7VPc=
Message-ID: <804dabb00803031701g368a7082q248cc2b05e762fa1@mail.gmail.com>
Date: Tue, 4 Mar 2008 09:01:51 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: ide_register_hw(): buggy code
Cc: "Adrian Bunk" <bunk@kernel.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200803032329.32020.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_13841_10618570.1204592511459"
References: <20080302151924.GJ25835@cs181133002.pp.htv.fi>
	 <804dabb00803030803v1dbbb33fh6779b8c4d072a908@mail.gmail.com>
	 <200803032329.32020.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_13841_10618570.1204592511459
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, Mar 4, 2008 at 6:29 AM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
>
>  Hi,
>
>
>  On Monday 03 March 2008, Peter Teoh wrote:
>  > On Sun, Mar 2, 2008 at 11:19 PM, Adrian Bunk <bunk@kernel.org> wrote:
>  > > The Coverity checker spotted the following bogus change to
>  > >  ide_register_hw() in commit 9e016a719209d95338e314b46c3012cc7feaaeec:
>  > >
>  > >  <--  snip  -->
>  > >
>  > >  ...
>  > >  +               hwif = ide_deprecated_find_port(hw->io_ports[IDE_DATA_OFFSET]);
>  > >  +               index = hwif->index;
>  > >  +               if (hwif)
>  > >  +                       goto found;
>  > >                 for (index = 0; index < MAX_HWIFS; index++)
>  > >  ...
>  > >
>  > >  <--  snip  -->
>  > >
>  > >  It's impossible to reach the for() loop without Oopsing before.
>
>  [ iff free hwif is not found (unlikely case) ]
>
>
>  > >  Can you either fix this for 2.6.25 or push your patch that removes
>  > >  ide_register_hw() for 2.6.25?
>  > >
>  >
>  > My question is:
>  >
>  > a.   why is "retry=1", and then the do while loop always end up the
>  > loop being one round executed only?   Why not just remove the while
>  > loop entirely?
>
>  the whole ide_register_hw() is already gone in IDE tree
>  (these patches are scheduled for 2.6.26)
>
>
>  > b.   not sure if your statement above implied this, but checking for
>  > hwif!=0 should be before index.  ???
>  >
>  > c.   "index = hwif->index;" should not be there, but after "found".
>  > Is that correct?
>
>  Yes, could you please re-do your patch to contain:
>
>  - only 'hwif->index' change
>  - proper patch description
>  - Signed-off-by: line
>
>  so I could merge it?


Description:

Relocating the index to come after finding the hwif pointer.

Thanks.

-- 
Regards,
Peter Teoh

------=_Part_13841_10618570.1204592511459
Content-Type: text/x-patch; name=relocating_deriving_index.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fddrmdxt0
Content-Disposition: attachment; filename=relocating_deriving_index.patch

U2lnbmVkLW9mZi1ieTogUGV0ZXIgVGVvaCA8aHRtbGRldmVsb3BlckBnbWFpbC5jb20+CgotLS0g
ZHJpdmVycy9pZGUvaWRlLmMub3JpZwkyMDA4LTAzLTA0IDA4OjI2OjExLjAwMDAwMDAwMCArMDgw
MAorKysgZHJpdmVycy9pZGUvaWRlLmMJMjAwOC0wMy0wNCAwOTowNzo0NC4wMDAwMDAwMDAgKzA4
MDAKQEAgLTY2Nyw3ICs2NjcsNiBAQCBpbnQgaWRlX3JlZ2lzdGVyX2h3KGh3X3JlZ3NfdCAqaHcs
IHZvaWQgCiAKIAlkbyB7CiAJCWh3aWYgPSBpZGVfZGVwcmVjYXRlZF9maW5kX3BvcnQoaHctPmlv
X3BvcnRzW0lERV9EQVRBX09GRlNFVF0pOwotCQlpbmRleCA9IGh3aWYtPmluZGV4OwogCQlpZiAo
aHdpZikKIAkJCWdvdG8gZm91bmQ7CiAJCWZvciAoaW5kZXggPSAwOyBpbmRleCA8IE1BWF9IV0lG
UzsgaW5kZXgrKykKQEAgLTY3NSw2ICs2NzQsNyBAQCBpbnQgaWRlX3JlZ2lzdGVyX2h3KGh3X3Jl
Z3NfdCAqaHcsIHZvaWQgCiAJfSB3aGlsZSAocmV0cnktLSk7CiAJcmV0dXJuIC0xOwogZm91bmQ6
CisJaW5kZXggPSBod2lmLT5pbmRleDsKIAlpZiAoaHdpZi0+cHJlc2VudCkKIAkJaWRlX3VucmVn
aXN0ZXIoaW5kZXgsIDAsIDEpOwogCWVsc2UgaWYgKCFod2lmLT5ob2xkKQo=
------=_Part_13841_10618570.1204592511459--
