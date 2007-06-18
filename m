Return-Path: <linux-kernel-owner+w=401wt.eu-S1763546AbXFRNq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763546AbXFRNq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 09:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762327AbXFRNqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 09:46:23 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:16329 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760614AbXFRNqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 09:46:22 -0400
Subject: Re: [RFC/PATCH] Documentation of kernel messages
From: holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Pavel Machek <pavel@ucw.cz>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, gregkh@suse.de,
       mtk-manpages@gmx.net, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>
In-Reply-To: <20070615124034.GH9442@ucw.cz>
References: <1181747217.29512.9.camel@localhost.localdomain>
	 <20070613111549.db1fa4d9.akpm@linux-foundation.org>
	 <20070614094128.GF17819@atrey.karlin.mff.cuni.cz>
	 <20070615124034.GH9442@ucw.cz>
Content-Type: text/plain
Organization: IBM
Date: Mon, 18 Jun 2007 15:42:34 +0200
Message-Id: <1182174154.11400.57.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Fri, 2007-06-15 at 12:40 +0000, Pavel Machek wrote:
> Hi!
> 
> > > Your proposal is similar to one I made to some Japanese developers
> > > earlier this year.  I was more modest, proposing that we
> > > 
> > > - add an enhanced printk
> > > 
> > > 	xxprintk(msgid, KERN_ERR "some text %d\n", some_number);
> >   Maybe a stupid idea but why do we want to assign these numbers by hand?
> > I can imagine it could introduce collisions when merging tons of patches
> > with new messages... Wouldn't it be better to compute say, 8-byte hash
> > from the message and use it as it's identifier? We could do this
> 
> Why hashes? Just key it off full message, and treat it like normal
> translation problem.
> 
> 'lp%d: on fire' -> 'your printer failed basic tests, you should check
> cabling'.

Hmmm... What about extracting all format strings from the KMSG_DOC
macros and storing them in a file. E.g.:

  printk("lp%d: on fire");

  /**
   * message
   *
   * Description:
   * Your printer failed basic tests, you should check cabling
   ...

  KMSG_DOC(lp, "lp%d: on fire");

Some build mechanism creates a file with all format strings of the
KMSG_DOC macros:

E.g.: cat kmsgs.txt

# MSG:       "lp%d: on fire"
# COMPONENT: lp
# DESC:      Your printer failed basic tests, you should check cabling

Then we provide a tool e.g. "kmsg", which gets as input the actual
kernel message and searches the message database for matching format
strings:

>> kmsg "lp0: on fire"
>> Your printer ...

Of course, we can get duplicate hits, too.

The advantage of that approach is, that we don't need additional message
identifiers like hashes.

Michael
 

