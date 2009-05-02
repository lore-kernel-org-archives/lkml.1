Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbZEBKls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbZEBKls (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 06:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZEBKlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 06:41:37 -0400
Received: from mail.samba.org ([66.70.73.150]:57365 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbZEBKlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 06:41:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18940.9039.850580.48730@samba.org>
Date: Sat, 2 May 2009 20:41:19 +1000
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
In-Reply-To: <87bpqbaji9.fsf@devron.myhome.or.jp>
References: <1241199689.13073.6.camel@norville.austin.ibm.com>
	<87fxfnbytu.fsf@devron.myhome.or.jp>
	<87ws8zak1m.fsf@devron.myhome.or.jp>
	<87bpqbaji9.fsf@devron.myhome.or.jp>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi writes:
 > Um.., probably, this patch would be handle the invalid chars for 8.3 alias.
 > Otherwise, it'll try to create ~<num> postfix, and I guess it'll become
 > the dcache problem.

Do you think that will cause problems? 

If it will, then we could add something like this after the
vfat_create_shortname() call:

	if (strncasecmp(name, msdos_name, MSDOS_NAME) != 0) {
		err = -EINVAL;
		goto out_free;
	}

or would the potential case change still be a problem?

Cheers, Tridge
