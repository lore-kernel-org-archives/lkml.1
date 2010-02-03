Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab0BCRM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:12:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60144
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757427Ab0BCRM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:12:56 -0500
Date: Wed, 03 Feb 2010 09:13:09 -0800 (PST)
Message-Id: <20100203.091309.52886984.davem@davemloft.net>
To: arnd@arndb.de
Cc: hch@lst.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, tony.luck@intel.com, ralf@linux-mips.org,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 4/6] improve sys_personality for compat architectures
From: David Miller <davem@davemloft.net>
In-Reply-To: <201002031806.27423.arnd@arndb.de>
References: <201002021536.51928.arnd@arndb.de>
	<20100202163145.GA30659@lst.de>
	<201002031806.27423.arnd@arndb.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 3 Feb 2010 18:06:27 +0100

>> But if the consensus is that we should fix this properly I can
>> replace the patch with one introducing a compat_sys_personality
>> which only gets used for compat tasks.
> 
> Right now, sparc64 and powerpc64 use sys32_personality for both native
> and compat tasks, x86 never uses it and all others use it only for
> compat tasks. That seems more sensible if we keep this function at
> all.

If it only gets used for compat tasks, you can only switch in
one direction.  I think it needs to be handled for both compat
and non-compat tasks, in order to allow for that.

That's why powerpc64 and sparc64 do things the way they do,
I am pretty sure.
