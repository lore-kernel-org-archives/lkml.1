Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbXFNI37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbXFNI37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 04:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbXFNI3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 04:29:51 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:19747 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbXFNI3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 04:29:49 -0400
Subject: Re: [RFC/PATCH] Documentation of kernel messages
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: holzheu@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, gregkh@suse.de, mtk-manpages@gmx.net,
       heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>
In-Reply-To: <20070613111549.db1fa4d9.akpm@linux-foundation.org>
References: <1181747217.29512.9.camel@localhost.localdomain>
	 <20070613111549.db1fa4d9.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 14 Jun 2007 10:31:04 +0200
Message-Id: <1181809864.5446.28.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-13 at 11:15 -0700, Andrew Morton wrote: 
> Your proposal is similar to one I made to some Japanese developers
> earlier this year.

Interesting. Our requirement comes from Japan as well.

>   I was more modest, proposing that we
> 
> - add an enhanced printk
> 
>         xxprintk(msgid, KERN_ERR "some text %d\n", some_number);

Some kind of id is always required to be able to identify the message.
The task is to make the tagging as simple as possible.

> - An externally managed database will provide translations, diagnostics,
>   remedial actions, etc, keyed off the msgid string

There I have my doubts if this can work. If you keep an external
database with the additional information about the messages the kernel
code and the database will get out of sync. Thats why we advocate the
kernel-doc style approach: the message catalogue will always be in sync
because it is delivered with the kernel.

> - Format and management of the msgid hasn't been clearly identified yet
>   as far as I know.  But all we really need is that each ID be unique,
>   kernel-wide.  We develop a simple tool which can check the whole tree
>   for duplicated msgids.

This is a paint point with Michaels approach as well. The KMSG_COMPONENT
defines are rather ugly. A clever way how to generate kernel unique IDs
would be nice. Intervention required..

> - From a practical day-to-day POV what this means is that a person
>   from the kernel-messages team will prepare a patch for your driver
>   which adds the msgids and you the driver author should take care not
>   to break the tagging.
> 
>   This is deliberately designed to be minimum-impact upon general 
>   developers.  We want a system in place where driver/fs/etc developers
>   can concentrate on what they do, and kernel-message developers can
>   as independently as possibe take care of what _they_ do.

With the KMSG approach all that needs to be done is to replace the
KERN_xxx with KMSG_xxx(<number) and to add a comment at the end of the
file.

> - A project has started up and there is a mailing list (cc'ed here) and
>   meetings are happening at the LF collaboration summit this week.
> 
>   Please see https://lists.linux-foundation.org/mailman/listinfo/lf_kernel_messages
>   and don't miss the next conference call ;)
> 
>   (argh.  The lf_kernel_messages archives are subscriber-only and it could be that
>   only members can post to it.  Oh well.  Please subscribe, and review the archives)

Very interesting. We did not know about this project. Thanks for the
hint.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


