Return-Path: <linux-kernel-owner+w=401wt.eu-S932908AbXCPJdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbXCPJdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 05:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932950AbXCPJde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 05:33:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50466
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932908AbXCPJdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 05:33:33 -0400
Date: Fri, 16 Mar 2007 02:33:31 -0700 (PDT)
Message-Id: <20070316.023331.59468179.davem@davemloft.net>
To: mingo@elte.hu
Cc: jeremy@goop.org, ak@muc.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au, anthony@codemonkey.ws,
       torvalds@linux-foundation.org
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070316092445.GM23174@elte.hu>
References: <20070301232443.195603797@goop.org>
	<20070301232527.956565107@goop.org>
	<20070316092445.GM23174@elte.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 16 Mar 2007 10:24:45 +0100

> ugh. This is beyond ugly! Why dont we just compile two images, one for 
> Xen and one for native, do two passes to get those two images and 
> 'merge' them into a single vmlinuz (so that we still have a 'single' 
> kernel unit to deal with on the distro side). This way we avoid all this 
> crazy, limited, fragile patchery business...

Perhaps the problem can be dealt with using ELF relocations.

There is another case, discussed yesterday on netdev, where run-time
resolution of ELF relocations would be useful (for
very-very-very-read-only variables) so if it can solve this problem
too it would be nice to have a generic infrastructure for it.
