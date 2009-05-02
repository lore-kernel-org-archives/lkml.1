Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbZEBMPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbZEBMPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 08:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbZEBMPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 08:15:36 -0400
Received: from mail.samba.org ([66.70.73.150]:40916 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbZEBMPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 08:15:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18940.14675.395802.635154@samba.org>
Date: Sat, 2 May 2009 22:15:15 +1000
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
In-Reply-To: <8763gj7m23.fsf@devron.myhome.or.jp>
References: <1241199689.13073.6.camel@norville.austin.ibm.com>
	<87fxfnbytu.fsf@devron.myhome.or.jp>
	<87ws8zak1m.fsf@devron.myhome.or.jp>
	<87bpqbaji9.fsf@devron.myhome.or.jp>
	<18940.9039.850580.48730@samba.org>
	<87ab5v9381.fsf@devron.myhome.or.jp>
	<18940.10942.989329.993465@samba.org>
	<87ocub7ngh.fsf@devron.myhome.or.jp>
	<18940.12667.429391.927727@samba.org>
	<8763gj7m23.fsf@devron.myhome.or.jp>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Ah. What is the intent to force WINNT option (lcase field)? To force it
 > may not be good. So, change default if config is on?

The idea behind forcing it is that it maintains maximum
functionality without the user having to use special mount
options. For example, if a Linux user creates a file "README.txt" then
the name will be preserved exactly, whereas without that hackery it
becomes README.TXT on disk.

It does mean we are mixing up two things with that config option
though, which is why I asked you about it. Would you prefer to just
let the distros worry about the default mount options when someone
plugs in a VFAT device on a system with
CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES set? 

Or maybe we should change the defaults in parse_options() when this
option is set?

Cheers, Tridge
