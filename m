Return-Path: <linux-kernel-owner+w=401wt.eu-S1751457AbXBCKHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbXBCKHq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 05:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbXBCKHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 05:07:46 -0500
Received: from 1wt.eu ([62.212.114.60]:2233 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbXBCKHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 05:07:45 -0500
Date: Sat, 3 Feb 2007 11:07:26 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mats Erik Andersson <mats.andersson64@comhem.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Three if-clauses of constant logic value; char drivers for kernel 2.4.33.3
Message-ID: <20070203100726.GA1307@1wt.eu>
References: <1166561978.4133.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1166561978.4133.26.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mats,

On Tue, Dec 19, 2006 at 09:59:37PM +0100, Mats Erik Andersson wrote:
> Hi there, all masters of kernel code,
> 
> I just discovered that the kernel code for 2.4.33.3 contains three
> if-statements that never can change their values, whence they should
> be repaired or eliminated. In source directory linux/drivers/char the
> files vt.c and keyboard.c produce these warning upon compilation:
> 
>     vt.c:166: varning: comparison is always false due to limited range  
>               of data type
>     vt.c:289: varning: comparison is always false due to limited range
>               of data type
>     keyboard.c:640: varning: comparison is always true due to limited
>                     range of data type
> 
> I did the compilation with gcc 3.3.5 on Debian Sarge. This behaviour
> appeared first for kernel 2.2.19, since I wanted to revive the old
> minirtl edition, but to my surprise the same warnings appear also
> with the brand new kernel 2.4.33.3.

I've looked at your warnings. They're all totally harmless, and caused
by safety checks against some defines in those functions. While in 2.6,
the two checks in vt.c have been removed, I can't be sure that nobody
in 2.4 changes the defines (eg: embedded systems) in which case the
checks would be totally valid.

So I will leave them. It may look annoying but it's a safe measure IMHO.

Best regards,
Willy

