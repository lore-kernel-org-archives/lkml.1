Return-Path: <linux-kernel-owner+w=401wt.eu-S1763013AbXHLDjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763013AbXHLDjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 23:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbXHLDjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 23:39:12 -0400
Received: from mail.ocs.com.au ([203.34.248.175]:22322 "EHLO mail.ocs.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927AbXHLDjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 23:39:11 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
From: Keith Owens <kaos@ocs.com.au>
To: casey@schaufler-ca.com
cc: Arjan van de Ven <arjan@infradead.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@osdl.org, torvalds@osdl.org
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel 
In-reply-to: Your message of "Sat, 11 Aug 2007 12:56:42 MST."
             <939644.96168.qm@web36607.mail.mud.yahoo.com> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sun, 12 Aug 2007 13:39:07 +1000
Message-ID: <3278.1186889947@ocs10w.ocs.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler (on Sat, 11 Aug 2007 12:56:42 -0700 (PDT)) wrote:
>
>--- Arjan van de Ven <arjan@infradead.org> wrote:
>> > +#include <linux/kernel.h>
>> > +#include <linux/vmalloc.h>
>> > +#include <linux/security.h>
>> > +#include <linux/mutex.h>
>> > +#include <net/netlabel.h>
>> > +#include "../../net/netlabel/netlabel_domainhash.h"
>> 
>> can't you move this header to include/ instead?
>
>Paul Moore, the developer of netlabel, promised to work out
>the right solution for this with me at a future date. He
>doesn't want to move the header, and I respect that.

foo.c has

#include "netlabel_domainhash.h"

Makefile has CFLAGS_foo.o += -I$(srctree)/net/netlabel

I prefer to use -I $(srctree)/net/netlabel for readability but '-I '
breaks on SuSE builds for some reason that I cannot be bothered working
out.  -I$(srctree)/net/netlabel works.

>> > +	doip = kmalloc(sizeof(struct cipso_v4_doi), GFP_KERNEL);
>> > +	if (doip == NULL)
>> > +		panic("smack:  Failed to initialize cipso DOI.\n");
>> > +	doip->map.std = NULL;
>> > +
>> > +	ndmp = kmalloc(sizeof(struct netlbl_dom_map), GFP_KERNEL);
>> > +	if (ndmp == NULL)
>> > +		panic("smack:  Failed to initialize cipso ndmp.\n");
>> 
>> 
>> is panic() really the right thing here? It's usually considered quite
>> rude ;)
>
>It's really early in start-up and if you're out of memory at that
>point you are not going very far into the future.

Not to mention that you might end up running with an insecure system.
Security must be failsafe.

