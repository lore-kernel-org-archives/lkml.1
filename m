Return-Path: <linux-kernel-owner+w=401wt.eu-S1752453AbYKMPvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbYKMPvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 10:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYKMPv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 10:51:28 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:55986 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbYKMPv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 10:51:27 -0500
Date: Fri, 14 Nov 2008 00:51:32 +0900 (JST)
Message-Id: <20081114.005132.78730934.anemo@mba.ocn.ne.jp>
To: vapier.adi@gmail.com
Cc: vapier@gentoo.org, linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: unify mtd partition/device registration
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <8bd0f97a0811130651k11c52a53j91c80cf196e9f66a@mail.gmail.com>
References: <20081113.224350.18312549.anemo@mba.ocn.ne.jp>
	<20081113.232823.125897716.anemo@mba.ocn.ne.jp>
	<8bd0f97a0811130651k11c52a53j91c80cf196e9f66a@mail.gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008 09:51:01 -0500, "Mike Frysinger" <vapier.adi@gmail.com> wrote:
> > Automatic fallback to mtd_device in parse_mtd() is convenient but
> > somewhat unflexible...
> 
> we could just have it do it all the time.  i dont see a problem with
> exposing the entire block device the whole time ?  i know for the
> driver or two of mine, i'm fine with it.
> 
> ...
>        ret = parse_mtd_partitions(mtd, probe_types, &parts, 0);
>        if (ret > 0) {
>                ret = add_mtd_partitions(mtd, parts, ret);
>                kfree(parts);
>        } else if (nr_parts)
>                ret = add_mtd_partitions(mtd, parts, nr_parts);
>        if (ret)
>                return ret;
> #endif
> 
>        return add_mtd_device(mtd);

I'm OK with this.  But not sure all current mtd partition users.

Are you going to convert all parse_mtd_partitions() call?  Maybe some
people do not want to change /dev/mtd numbers...

---
Atsushi Nemoto
