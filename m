Return-Path: <linux-kernel-owner+w=401wt.eu-S1758998AbZBFWSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758998AbZBFWSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 17:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbZBFWSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 17:18:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60870
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755483AbZBFWSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 17:18:35 -0500
Date: Fri, 06 Feb 2009 14:18:31 -0800 (PST)
Message-Id: <20090206.141831.248558063.davem@davemloft.net>
To: roland@redhat.com
Cc: akpm@linux-foundation.org, gerald.schaefer@de.ibm.com,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, torvalds@linux-foundation.org
Subject: Re: [BUG] binfmt_elf: get_user() called in vma_dump_size() after
 set_fs(KERNEL_DS)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090206220717.AE750FC3AD@magilla.sf.frob.com>
References: <1233940235.22140.9.camel@localhost.localdomain>
	<20090206134410.d548b72c.akpm@linux-foundation.org>
	<20090206220717.AE750FC3AD@magilla.sf.frob.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland McGrath <roland@redhat.com>
Date: Fri,  6 Feb 2009 14:07:17 -0800 (PST)

> set_fs is quite cheap at least on most machines.  So a pair of set_fs calls
> around that get_user call doesn't seem so bad.  OTOH, on the machines where
> this actually matters at all (maybe just sparc, arm, s390?) it is
> presumably (much?) more costly.  But it seems like the best solution, and
> certainly is straightforward.

On sparc set_fs() is just a privileged register write, so pretty cheap
and definitely less expensive than get_user_pages() :-)
