Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbZH0KTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbZH0KTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 06:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZH0KTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 06:19:23 -0400
Received: from ozlabs.org ([203.10.76.45]:57719 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbZH0KTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 06:19:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] allow disabling IMA at runtime
Date: Thu, 27 Aug 2009 19:49:19 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Kyle McMartin <kyle@mcmartin.ca>, zohar@us.ibm.com,
       linux-kernel@vger.kernel.org, eparis@redhat.com,
       torvalds@linux-foundation.org, James Morris <jmorris@namei.org>
References: <20090826021005.GD19494@bombadil.infradead.org> <20090826170225.7574759e.akpm@linux-foundation.org>
In-Reply-To: <20090826170225.7574759e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908271949.20185.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009 09:32:25 am Andrew Morton wrote:
>   From my reading of kernel/params.c:parse_args(), every __setup()
>   function which returns `1' should result in printk("%s: `%s' invalid
>   for parameter `%s'), so I'm all confused and giving up.

Nope, it's an "obsolete_param", so non-zero means success.

> > +__setup("ima=", ima_enabled);
> 
> Are we supposed to use core_param() nowadays?

Yeah, if this had backwards compatibility requirements.  But for new,
non-core params like this:

1) make sure the module is called "ima" (even if not a module: make the
   object ima.o)

2) use module_param(), and make your parameters "disable" and "audit"
   (ima_disable and ima_audit if must be nonstatic and use module_param_named).
   You don't need to write any parse functions at all!

3) Tell users to use ima.disable and ima.audit.

Thanks,
Rusty.
