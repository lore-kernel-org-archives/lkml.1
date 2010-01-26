Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492Ab0AZEEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab0AZEEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 23:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126Ab0AZEEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 23:04:06 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:19042 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab0AZEEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 23:04:05 -0500
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAAb4XUurR7Hu/2dsb2JhbADCepZyhDkE
X-IronPort-AV: E=Sophos;i="4.49,344,1262563200"; 
   d="scan'208";a="235397777"
From: Roland Dreier <rdreier@cisco.com>
To: Alex Chiang <achiang@hp.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: infiniband limit of 32 cards per system?
References: <20100125235013.GD2828@grease.ALLEYCAT>
	<adaiqapplv7.fsf@roland-alpha.cisco.com>
	<20100126035906.GA23347@ldl.fc.hp.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 25 Jan 2010 20:03:58 -0800
In-Reply-To: <20100126035906.GA23347@ldl.fc.hp.com> (Alex Chiang's message of
	"Mon, 25 Jan 2010 20:59:06 -0700")
Message-ID: <adaaaw1pl5d.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Jan 2010 04:04:02.0331 (UTC) FILETIME=[984426B0:01CA9E3C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > I'm guessing that it's not just a simple kernel fix though since
 > OFED has to change too, right?

Dunno about OFED.  Nothing sane is hard-coding major/minor numbers
though -- so I think OFED should be OK, asuming there are no crazy
scripts that bypass udev creating device nodes etc.

I don't think that it's _totally_ trivial in the kernel -- we do need to
add some code in several places to allocate dynamic device numbers when
we run out of the static allocation (probably best to keep the legacy
device numbers for "small" < 32 adapter systems, since there may be
really small systems with static hard-coded /dev etc).

 - R.

