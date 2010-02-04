Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0BDFsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 00:48:40 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49031 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab0BDFsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 00:48:38 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 4 Feb 2010 14:45:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Oleg Kutkov <elenbert@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem with set_memory_rw
Message-Id: <20100204144511.b50d3191.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4B6A5A81.2030207@gmail.com>
References: <4B6A5A81.2030207@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Feb 2010 07:26:25 +0200
Oleg Kutkov <elenbert@gmail.com> wrote:

> Hello, this is my first post in a mailing list, so excuse me if 
> something wrong...
> I'm new in kernel and try to do some manipulation with memory pages.
> For manipulating memory page attributes i used set_memory_rw(),
> but function returning 0 and i can't continue writing to memory,
> because page, that i want to change, is read only by default.
> This is part of my code:
> 
> 
> long unsigned addr;
> 
> addr = 0x0509940;              //this is addres in memory, that i  want 
> to overwrite (read only, for default)
> 
> set_memory_rw(addr, 1);    //try to set rw permission on this addres for 
> one memory page.
> 
> 
> So, function return zero, this is error, as i can understand. If i try 
> to write by this address - kernel write in log error messages, such as 
> "Unable to handle kernel request at address 0x0509940".
> This is kernel bug or something wrong in my code?
> 
> Thank for any help.
> 

set_memory_rw()'s 1st argument requires virtual address.
So, you need virtual address of the page you want.
 
  - phys_to_virt() ... convert physical address to virtual address.
  - virt_to_phys() ... convert virtual address to physical.

Anyway, RW is vitual address mapping's attribute and not for physical.

Thanks,
-Kame


