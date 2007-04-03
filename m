Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbXDCT1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbXDCT1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbXDCT1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:27:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43264
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753646AbXDCT1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:27:09 -0400
Date: Tue, 03 Apr 2007 12:27:08 -0700 (PDT)
Message-Id: <20070403.122708.116354009.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, sam@ravnborg.org
Subject: Re: [PATCH] make csum_partial obj-y
From: David Miller <davem@davemloft.net>
In-Reply-To: <4612A66D.5090009@oracle.com>
References: <20070403112604.129610b1.randy.dunlap@oracle.com>
	<p731wj1z0or.fsf@bingen.suse.de>
	<4612A66D.5090009@oracle.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 03 Apr 2007 12:09:33 -0700

> How does the networking code work across multiple architectures?

This has been discussed before.

The csum_partial() result value is only well defined modulo 0xffff.

The networking does csum_fold() or similar on the results, and so the
right thing always happens there.

The reiserfs case is the worst because even ignoring the differences
in csum_partial() return values, it always feeds this into
cpu_to_le32() which basically means that it is putting a cpu-endian
dependent value onto disk.  csum_partial() returns a fixed-endian,
not cpu endian, value.  So feeding it into cpu_to_anything() is
quite wrong.


