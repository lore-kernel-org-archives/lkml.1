Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbZEBLNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbZEBLNa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 07:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbZEBLNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 07:13:19 -0400
Received: from mail.samba.org ([66.70.73.150]:58306 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbZEBLNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 07:13:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18940.10942.989329.993465@samba.org>
Date: Sat, 2 May 2009 21:13:02 +1000
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
In-Reply-To: <87ab5v9381.fsf@devron.myhome.or.jp>
References: <1241199689.13073.6.camel@norville.austin.ibm.com>
	<87fxfnbytu.fsf@devron.myhome.or.jp>
	<87ws8zak1m.fsf@devron.myhome.or.jp>
	<87bpqbaji9.fsf@devron.myhome.or.jp>
	<18940.9039.850580.48730@samba.org>
	<87ab5v9381.fsf@devron.myhome.or.jp>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hirofumi-san,

 > It may be ok. However, of course, it should consider other than
 > ascii. Well, I think the patch should be allow only perfect 8.3 name in
 > vfat_create_shortname(). (i.e. is_shortname && base/ext_info.valid)

ok, so something like this in vfat_create_shortname() ?

#ifdef CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES
	if (is_shortname == 0 ||
	    !(base_info.valid && ext_info.valid))
		return -ENAMETOOLONG;
	shortname_flags = VFAT_SFN_CREATE_WINNT;
#endif

that still means that creating a file ShortNam.TxT actually creates
shortnam.txt on disk. Will the case-insensitive vfat_cmpi used as
d_compare cope OK with that?

Cheers, Tridge
