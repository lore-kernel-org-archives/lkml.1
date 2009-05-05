Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZEEGVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZEEGVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 02:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbZEEGU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 02:20:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:62768 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbZEEGU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 02:20:56 -0400
Date: Tue, 5 May 2009 08:22:05 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Kwangwoo Lee <kwangwoo.lee@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] input: Add support for the TSC2003 controller.
Message-ID: <20090505062205.GA28440@avionic-design.de>
References: <1241006627-22811-1-git-send-email-thierry.reding@avionic-design.de> <5d5443650904290623n3712cd7dja653a139cff2cf6d@mail.gmail.com> <483a38b80904291835p51044741p9bd83d33a40031c@mail.gmail.com> <20090504113751.GA22603@avionic-design.de> <5d5443650905040503n501e3b47qc890dc4c71a85b1c@mail.gmail.com> <20090504145700.GA875@avionic-design.de> <5d5443650905041021n1f709ce1y382440d1285b09ec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="A6N2fC+uXW/VQSAv"
Content-Disposition: inline
In-Reply-To: <5d5443650905041021n1f709ce1y382440d1285b09ec@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Provags-ID: V01U2FsdGVkX18tgXVIptsXduS4jWIa1EZ4rV2KsL/R6whmHzd
 BNf3Nt70ydlJ6CWIrnTUiQJK6DTtmu4b7ni73NAI6nl9sx1Yjg
 /Tgp/qcAKqb5tswXXW42g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Trilok Soni wrote:
> Hi Therry,
> 
> On Mon, May 4, 2009 at 8:27 PM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> > * Trilok Soni wrote:
> >> Hi Thierry,
> >>
> >> On Mon, May 4, 2009 at 5:07 PM, Thierry Reding
> >> <thierry.reding@avionic-design.de> wrote:
> >> > * Kwangwoo Lee wrote:
> >> >> Hi Thierry and Trilok,
> >> >>
> >> >> On Wed, Apr 29, 2009 at 10:23 PM, Trilok Soni <soni.trilok@gmail.com> wrote:
> >> >> > Hi Thierry,
> >> >> >
> >> >> > I have added linux-omap community. How different is this chip from
> >> >> > tsc2007. It looks to me that this chip is not much different from
> >> >> > tsc2007 (this is just quick look at the driver). If they
> >> >> > are similar please consider using i2c_device_id feature in tsc2007 to
> >> >> > accommodate this chip.
> >> >>
> >> >> I agree with the Trilok's opinion.
> >> > [snip]
> >> >
> >> > I only noticed the tsc2007 driver some time ago, when the tsc2003 was already
> >> > finished (it's actually pretty old, I just never got around to submitting
> >> > it). However I never got the tsc2007 to work on my platform because it uses
> >> > sleeping functions inside the timer handler, which results in an oops right
> >> > after the first touchscreen interrupt.
> >> >
> >> > I guess I could try and fix the tsc2007 properly instead of having a second,
> >> > pretty similar driver in the tree.
> >> >
> >>
> >> This could be because of improper locking? If you share a crash we can
> >> have look at it.
> >
> > Attached is a patch that fixes things for me. The problem was that the I2C
> > transfers were done in interrupt context which fails for the controller I use
> > (PXA270). The attached patch uses a struct work_struct to schedule the I2C
> > transfers so they are executed in non-interrupt context.
> >
> > I've tested the patch on a minimal system with tslib and it work fine with
> > ts_calibrate and friends.
> 
> Thanks for the patch. It looks good. Let's wait for Kwangwoo Lee to
> verify it on his platform. Also please add "tsc2003" entry into
> i2c_device_ids so that i2c_board_info can specify the .name as
> "tsc2003".

A second patch is attached that merely adds the tsc2003 to the list of
supported device IDs. I've split the patch off because it has nothing to do
with the other changes.

Thierry


--A6N2fC+uXW/VQSAv
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="tsc003.patch"
Content-Transfer-Encoding: quoted-printable

=46rom: Thierry Reding <thierry.reding@avionic-design.de>
Subject: [PATCH] tsc2007: Add support for TSC2003 chips.

The TSC2003 is very similar to the TSC2007 an can be supported by the same
driver with no additional changes.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

---
 drivers/input/touchscreen/tsc2007.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscree=
n/tsc2007.c
index 6efb54d..599aa67 100644
--- a/drivers/input/touchscreen/tsc2007.c
+++ b/drivers/input/touchscreen/tsc2007.c
@@ -360,6 +360,7 @@ static int tsc2007_remove(struct i2c_client *client)
=20
 static struct i2c_device_id tsc2007_idtable[] =3D {
 	{ "tsc2007", 0 },
+	{ "tsc2003", 0 },
 	{ }
 };
=20
--=20
tg: (84e274c..) adx/input/tsc2003 (depends on: adx/input/tsc2007)

--A6N2fC+uXW/VQSAv--
