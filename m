Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbYLDFXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbYLDFXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 00:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYLDFXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 00:23:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59268
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752000AbYLDFXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 00:23:13 -0500
Date: Wed, 03 Dec 2008 21:23:13 -0800 (PST)
Message-Id: <20081203.212313.74138057.davem@davemloft.net>
To: paulus@samba.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Joakim.Tjernlund@transmode.se
Subject: Re: [PATCH] Allow times and time system calls to return small
 negative values
From: David Miller <davem@davemloft.net>
In-Reply-To: <18743.25968.602602.875295@drongo.ozlabs.ibm.com>
References: <18743.25968.602602.875295@drongo.ozlabs.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Thu, 4 Dec 2008 16:06:56 +1100

> At the moment, the times() system call will appear to fail for a
> period shortly after boot, while the value it want to return is
> between -4095 and -1.  The same thing will also happen for the time()
> system call on 32-bit platforms some time in 2106 or so.
> 
> On some platforms, such as x86, this is unavoidable because of the
> system call ABI, but other platforms such as powerpc have a separate
> error indication from the return value, so system calls can in fact
> return small negative values without indicating an error.  On those
> platforms, force_successful_syscall_return() provides a way to
> indicate that the system call return value should not be treated as an
> error even if it is in the range which would normally be taken as a
> negative error number.
> 
> This adds a force_successful_syscall_return() call to the time() and
> times() system calls plus their 32-bit compat versions, so that they
> don't erroneously indicate an error on those platforms whose system
> call ABI has a separate error indication.  This will not affect
> anything on other platforms.
> 
> Joakim Tjernlund added the fix for time() and the compat versions of
> time() and times(), after I did the fix for times().
> 
> Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
> Signed-off-by: Paul Mackerras <paulus@samba.org>

Acked-by: David S. Miller <davem@davemloft.net>
