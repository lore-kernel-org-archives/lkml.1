Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbZEBL3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbZEBL3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 07:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZEBL3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 07:29:09 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:46286 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbZEBL3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 07:29:07 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: tridge@samba.org
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
References: <1241199689.13073.6.camel@norville.austin.ibm.com>
	<87fxfnbytu.fsf@devron.myhome.or.jp>
	<87ws8zak1m.fsf@devron.myhome.or.jp>
	<87bpqbaji9.fsf@devron.myhome.or.jp>
	<18940.9039.850580.48730@samba.org>
	<87ab5v9381.fsf@devron.myhome.or.jp>
	<18940.10942.989329.993465@samba.org>
Date: Sat, 02 May 2009 20:29:02 +0900
In-Reply-To: <18940.10942.989329.993465@samba.org> (tridge@samba.org's message
	of "Sat, 2 May 2009 21:13:02 +1000")
Message-ID: <87ocub7ngh.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org writes:

> Hi Hirofumi-san,
>
>  > It may be ok. However, of course, it should consider other than
>  > ascii. Well, I think the patch should be allow only perfect 8.3 name in
>  > vfat_create_shortname(). (i.e. is_shortname && base/ext_info.valid)
>
> ok, so something like this in vfat_create_shortname() ?
>
> #ifdef CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES
> 	if (is_shortname == 0 ||
> 	    !(base_info.valid && ext_info.valid))
> 		return -ENAMETOOLONG;
> 	shortname_flags = VFAT_SFN_CREATE_WINNT;
> #endif

Yes. I guess -ENAMETOOLONG would not good for !valid, and !(is_shortname
&& base_info.valid && ext_info.valid) or add "else" part is more prefer
though.

> that still means that creating a file ShortNam.TxT actually creates
> shortnam.txt on disk. Will the case-insensitive vfat_cmpi used as
> d_compare cope OK with that?

Yes. The case-insensitive is ok, the dcache can handle case-insensitive.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
