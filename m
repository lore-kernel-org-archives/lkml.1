Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052AbYGXGqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbYGXGqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 02:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYGXGp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 02:45:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33146
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751040AbYGXGp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 02:45:56 -0400
Date: Wed, 23 Jul 2008 23:45:56 -0700 (PDT)
Message-Id: <20080723.234556.98132946.davem@davemloft.net>
To: pupilla@hotmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.26: [<c0133cc1>] __alloc_pages_internal+0x331/0x343
From: David Miller <davem@davemloft.net>
In-Reply-To: <BAY103-DAV1DBA31C9BCB4C6FFB3DE0B2870@phx.gbl>
References: <BAY103-DAV1DBA31C9BCB4C6FFB3DE0B2870@phx.gbl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Marco Berizzi" <pupilla@hotmail.com>
Date: Thu, 24 Jul 2008 08:39:48 +0200

> Jul 23 12:40:02 Electra kernel: crond: page allocation failure. order:5,
> mode:0x4020
> Jul 23 12:40:02 Electra kernel: Pid: 586, comm: crond Not tainted 2.6.26
> #1
> Jul 23 12:40:02 Electra kernel:  [<c0135e93>]
> __alloc_pages_internal+0x226/0x393
> Jul 23 12:40:02 Electra kernel:  [<c0136007>] __alloc_pages+0x7/0x9
> Jul 23 12:40:02 Electra kernel:  [<c013602a>] __get_free_pages+0x16/0x32
> Jul 23 12:40:03 Electra kernel:  [<c024d2a5>]
> pskb_expand_head+0x41/0x164
> Jul 23 12:40:03 Electra kernel:  [<c029a6b4>]
> ipcomp_decompress+0x60/0xa1

ipcomp_decompress() should probably be changed to try and build
a scatterlist of pages for the resulting packet SKB data instead
of building a linear buffer as it does now.
