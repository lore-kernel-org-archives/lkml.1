Return-Path: <linux-kernel-owner+w=401wt.eu-S965282AbXA3MXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965282AbXA3MXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 07:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965171AbXA3MXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 07:23:53 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:46311 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965282AbXA3MXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 07:23:52 -0500
Subject: Re: + mm-search_binary_handler-mem-limit-fix.patch added to -mm
	tree
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Dmitriy Monakhov <dmonakhov@sw.ru>
Cc: Andrew Morton <akpm@osdl.org>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, dmonakhov@openvz.org
In-Reply-To: <87veipxeac.fsf@sw.ru>
References: <200701240909.l0O99IwK013495@shell0.pdx.osdl.net>
	 <20070129113328.GA9941@osiris.boeblingen.de.ibm.com>
	 <20070129135958.GB9941@osiris.boeblingen.de.ibm.com>
	 <20070129093751.a1637a68.akpm@osdl.org>
	 <1170094705.17738.11.camel@localhost>  <87veipxeac.fsf@sw.ru>
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 30 Jan 2007 13:23:49 +0100
Message-Id: <1170159829.22550.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-30 at 08:40 +0300, Dmitriy Monakhov wrote:
> > > > The function changes mem limit to USER_DS before possible modprobe, but
> > > > never restored it again.
> Truly. The road to hell is paved with good intentions.

:-)

> > For architectures with a split address space there has to be a call
> > set_fs(USER_DS) that switches from KERNEL_DS to USER_DS for the init
> > process. So far this has been done in search_binary_handler and
> > traditionally the kernel starts with KERNEL_DS to make the early
> > copy_from_user calls work.
> > So, what is wrong with always setting USER_DS? We are starting a user
> > space process after all.
> May be add some comment to prevent future attempts to make this place 
> more "correct"?

The use of set_fs(USER_DS) in search_binary_handler is certainly
different compared to the rest. It probably is the only one that is not
paired with a set_fs(KERNEL_DS) or set_fs(old_fs). A comment won't hurt.

-- 
blue skies,
  Martin.

Martin Schwidefsky
Linux for zSeries Development & Services
IBM Deutschland Entwicklung GmbH

"Reality continues to ruin my life." - Calvin.


