Return-Path: <linux-kernel-owner+w=401wt.eu-S1752717AbXCRAqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbXCRAqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 20:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbXCRAqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 20:46:19 -0400
Received: from ozlabs.org ([203.10.76.45]:32882 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbXCRAqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 20:46:17 -0400
Subject: Re: [PATCH RESEND 2/2] Fix some kallsyms_lookup() vs rmmod races
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org,
       mingo@elte.hu, tglx@linutronix.de, viro@zeniv.linux.org.uk,
       pmarques@grupopie.com
In-Reply-To: <20070316114458.GB6817@localhost.sw.ru>
References: <20070316114458.GB6817@localhost.sw.ru>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 20:32:51 +1100
Message-Id: <1174123971.8897.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 14:44 +0300, Alexey Dobriyan wrote:
> [cc'ing folks whose proc files are affected]
> 
> kallsyms_lookup() can call module_address_lookup() which iterates over
> modules list without module_mutex taken. Comment at the top of
> module_address_lookup() says it's for oops resolution so races are
> irrelevant, but in some cases it's reachable from regular code:

Yes, this changed somewhere along the way. 

I prefer keeping the lock internal as much as possible, and have the
crash code use an __ variant of the function.

Note also that it might be an idea to have less-powerful accessors than
kallsyms_lookup...

Thanks!
Rusty.


