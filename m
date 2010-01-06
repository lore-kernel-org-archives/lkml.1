Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369Ab0AFHIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab0AFHIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 02:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476Ab0AFHIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 02:08:16 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:53140 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab0AFHIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 02:08:15 -0500
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABbGQ0urRN+J/2dsb2JhbAC/AZQ9hDAE
X-IronPort-AV: E=Sophos;i="4.49,227,1262563200"; 
   d="scan'208";a="70635992"
From: Roland Dreier <rdreier@cisco.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: O_* bit numbers uniqueness check
References: <20100106065526.GB11368@localhost>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 05 Jan 2010 23:08:08 -0800
In-Reply-To: <20100106065526.GB11368@localhost> (Wu Fengguang's message of
	"Wed, 6 Jan 2010 14:55:26 +0800")
Message-ID: <adahbqzvhgn.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Jan 2010 07:08:09.0098 (UTC) FILETIME=[006406A0:01CA8E9F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > +	/* please add new bits here to ensure allocation uniqueness */
 > +	BUG_ON(20 != hweight32(
 > +		O_RDONLY	| O_WRONLY	| O_RDWR	|

I wonder if there's a way to make this BUILD_BUG_ON(), so the problem is
caught at compile time (a change like adding an O_ flag is often compile
tested only for obscure archs).  One could create a compile-time
macro-ized version of hweight32() and use that, I guess, although I'm
not sure it's worth the ugliness.

Failing that maybe this should be WARN_ON()?  I'd be annoyed if my arch
wouldn't boot because some strange new O_ flag happened to collide.

 - R.
