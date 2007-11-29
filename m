Return-Path: <linux-kernel-owner+w=401wt.eu-S1762628AbXK2BNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762628AbXK2BNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761787AbXK2BNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:13:31 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:52211 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761911AbXK2BNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:13:30 -0500
To: =?us-ascii?Q?=3D=3Futf-8=3Fq=3FFerenc=5FW=3DC3=3DA1gner=3F=3D?= 
	<wferi@niif.hu>
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] net/bonding: Return nothing for not applicable values 
In-reply-to: <87wss3jin5.fsf@szonett.ki.iif.hu> 
References: <87wss3jin5.fsf@szonett.ki.iif.hu>
Comments: In-reply-to =?us-ascii?Q?=3D=3Futf-8=3Fq=3FFerenc=5FW=3DC3=3DA1gner=3F=3D?= <wferi@niif.hu>
   message dated "Wed, 28 Nov 2007 01:52:46 +0100."
X-Mailer: MH-E 8.0.3; nmh 1.1-RC4; GNU Emacs 22.0.95
Date: Wed, 28 Nov 2007 17:13:15 -0800
Message-ID: <26966.1196298795@death>
From: Jay Vosburgh <fubar@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>The previous code returned '\n' (that is, a single empty line)
>from most files, with one exception (xmit_hash_policy), where
>it returned 'NA\n'.  This patch consolidates each file to return
>nothing at all if not applicable, not even a '\n'.
>
>I find this behaviour more usual, more useful, more efficient
>and shorter to code from both sides.
[...]
>+	if ((bond->params.mode == BOND_MODE_XOR) ||
>+	    (bond->params.mode == BOND_MODE_8023AD)) {
> 		count = sprintf(buf, "%s %d\n",
> 			xmit_hashtype_tbl[bond->params.xmit_policy].modename,
> 			bond->params.xmit_policy);

	Rather than this (returning nothing if not in xor or 802.3ad
mode), I'd prefer to see this always return whatever the xmit policy is
(regardless of the mode), and remove the mode test from
bonding_store_xmit_hash().

	This would be consistent with the way the arp_ip_target option
is treated: the actual value is always displayed, even if it is not
used, and it is legal to change the value, regardless of the mode.

	Other than this, I'm fine with the changes.

	-J

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
