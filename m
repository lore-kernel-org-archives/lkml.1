Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbXA2SS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbXA2SS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 13:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbXA2SS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 13:18:29 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:46521 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbXA2SS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 13:18:28 -0500
Subject: Re: + mm-search_binary_handler-mem-limit-fix.patch added to -mm
	tree
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Andrew Morton <akpm@osdl.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       dmonakhov@openvz.org
In-Reply-To: <20070129093751.a1637a68.akpm@osdl.org>
References: <200701240909.l0O99IwK013495@shell0.pdx.osdl.net>
	 <20070129113328.GA9941@osiris.boeblingen.de.ibm.com>
	 <20070129135958.GB9941@osiris.boeblingen.de.ibm.com>
	 <20070129093751.a1637a68.akpm@osdl.org>
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 29 Jan 2007 19:18:25 +0100
Message-Id: <1170094705.17738.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-01-29 at 09:37 -0800, Andrew Morton wrote:
> hm, thanks for testing - I'll drop it.
> 
> I don't really understand what's wrong with it though.  Maybe it's settng
> USER_DS on kernel threads?

For architectures with a split address space there has to be a call
set_fs(USER_DS) that switches from KERNEL_DS to USER_DS for the init
process. So far this has been done in search_binary_handler and
traditionally the kernel starts with KERNEL_DS to make the early
copy_from_user calls work.
So, what is wrong with always setting USER_DS? We are starting a user
space process after all.

-- 
blue skies,
  Martin.

Martin Schwidefsky
Linux for zSeries Development & Services
IBM Deutschland Entwicklung GmbH

"Reality continues to ruin my life." - Calvin.


