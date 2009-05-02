Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbZEBKcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbZEBKcZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 06:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZEBKcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 06:32:14 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:51753 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbZEBKcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 06:32:14 -0400
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
	<18940.7781.437239.963551@samba.org>
Date: Sat, 02 May 2009 19:32:11 +0900
In-Reply-To: <18940.7781.437239.963551@samba.org> (tridge@samba.org's message
	of "Sat, 2 May 2009 20:20:21 +1000")
Message-ID: <87skjn94no.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org writes:

> OGAWA Hirofumi writes:
>  > I'll answer to only technical part. This patch creates different name
>  > internally, without renaming dcache. Are you really sure if that's ok?
>
> The name handling should be the same as the existing code path where
> goto shortname is done after vfat_create_shortname() in
> vfat_build_slots() (ie. when the name conformed to 8.3).
>
> What situation are you thinking of which this would cause a problem?

At this answer, I was missing the (is_shortname == 0).

However, if filename contains the chars in vfat_replace_char(). It will
have similar problem. In this case, this patch creates the dir entry
without longname. So, it wouldn't match to dcache and real dir entries.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
