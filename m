Return-Path: <linux-kernel-owner+w=401wt.eu-S1752062AbXDIPKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbXDIPKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 11:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXDIPK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 11:10:29 -0400
Received: from mga05.intel.com ([192.55.52.89]:12137 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752062AbXDIPK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 11:10:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,388,1170662400"; 
   d="scan'208"; a="227088200:sNHT27661522"
Message-ID: <461A5733.3080303@linux.intel.com>
Date: Mon, 09 Apr 2007 08:09:39 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Pavel Emelianov <xemul@sw.ru>
CC: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Lockdep treats down_write_trylock like regular down_write
References: <461A0DDC.5060709@sw.ru>
In-Reply-To: <461A0DDC.5060709@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov wrote:
> This causes constructions like
> 
> down_write(&mm1->mmap_sem);
> if (down_write_trylock(&mm2->mmap_sem)) {
>        ...
>        up_write(&mm2->mmap_sem);
> }
> up_write(&mm1->mmap_sem);
> 
> generate a lockdep warning about circular locking dependence.

please show me why this is safe, especially if you intermix it with 
down_read()'s... like copy_to_user and co may do.

this feels like a very unsafe construct to me...
