Return-Path: <linux-kernel-owner+w=401wt.eu-S1760379AbZDSG2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379AbZDSG2U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 02:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbZDSG2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 02:28:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410AbZDSG2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 02:28:03 -0400
From: Neil Brown <neilb@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>,
       "Matti Aarnio" <matti.aarnio@zmailer.org>,
       "Jesper Juhl" <jj@chaosbits.net>,
       "Prakash Punnoor" <prakash@punnoor.de>,
       "Michael Tokarev" <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Date: Sun, 19 Apr 2009 16:28:11 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18922.50299.133847.743973@notabene.brown>
Subject: Re: Proposal: make RAID6 code optional
In-Reply-To: message from NeilBrown on Sunday April 19
References: <200904180946.27722.prakash@punnoor.de>
	<49E98AD2.8060601@msgid.tls.msk.ru>
	<200904181117.03418.prakash@punnoor.de>
	<alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net>
	<20090418145850.GD28512@mea-ext.zmailer.org>
	<49EA8766.9070605@zytor.com>
	<2954ad7f6081b2a6da33f861b0654626.squirrel@neil.brown.name>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday April 19, neilb@suse.de wrote:
> 
> In 2.6.30, the Q syndrome code has been moved into a separate module,
> so raid456.ko should be quite a bit smaller.

Of course that doesn't really help as there will be a dependency
between raid456.ko and pq.ko so you cannot avoid having pq.ko loaded
while using raid5.

It might make sense to create a raid6 module that just contains 
The call to register_md_personality(raid6_personality) and some
linkage so that the code in raid456.ko can get to the code in pq.ko.

This is probably worth trying one the raid6 async offload stuff
stabilises.

NeilBrown
