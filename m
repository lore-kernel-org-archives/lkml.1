Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbYCCK5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbYCCK5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbYCCK5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:57:32 -0500
Received: from mail.tnp-online.de ([212.80.247.147]:58268 "EHLO
	fallback.gigamail.to" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbYCCK5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:57:30 -0500
From: Arne Redlich <arne.redlich@xiranet.com>
To: Roland Dreier <rolandd@cisco.com>
Cc: ofa-general <general@lists.openfabrics.org>,
       lkml <linux-kernel@vger.kernel.org>, erezz@voltaire.com
Subject: [PATCH 0/2] IB/iSER bugfixes
Date: Mon, 03 Mar 2008 11:35:48 +0100
Message-ID: <87ejasxfgb.fsf@confield.dd.xiranet.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-xiranet-MailScanner-OpenProtect-Information: Please contact the ISP for more information
X-xiranet-MailScanner-OpenProtect: Found to be clean
X-xiranet-MailScanner-OpenProtect-MCPCheck: 
X-xiranet-MailScanner-OpenProtect-From: arne.redlich@xiranet.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While reading through the iSER code I noticed two rather nasty issues:

1. The iteration through the list of "iser_device"s during device
lookup/creation is broken - it might result in an infinite loop if more
than 1 HCA is used with iSER. Use list_for_each_entry() instead of the
custom, flawed list iteration code.

2. "iser_device" allocation failure is "handled" with a BUG_ON() right
before dereferencing the NULL-pointer.
This is really scary, so here's my idea of a fix. Someone with a deeper
understanding of the code should have a look at it since I'm not sure it
does The Right Thing.

Both patches are merely compile tested, and patch #2 needs to be applied
on top of #1.

Cheers,
Arne
