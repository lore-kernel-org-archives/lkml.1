Return-Path: <linux-kernel-owner+w=401wt.eu-S933366AbXHOPAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366AbXHOPAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 11:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765222AbXHOO7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:59:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755733AbXHOO7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:59:42 -0400
Message-ID: <46C314D6.6090402@redhat.com>
Date: Wed, 15 Aug 2007 09:59:34 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>, security@kernel.org
Subject: Re: [PATCH V3] limit minixfs printks on corrupted dir i_size, CVE-2006-6058
References: <8Qlff-3jX-29@gated-at.bofh.it> <8Qn7m-6li-27@gated-at.bofh.it> <E1IJFr4-0000is-Ox@be1.lrz> <46C09AE0.5010902@redhat.com> <Pine.LNX.4.58.0708151345220.3232@be1.lrz>
In-Reply-To: <Pine.LNX.4.58.0708151345220.3232@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:

>> Ok, do you like this slightly better?  It states the subsystem, the 
>> function with the error, the block nr. in the case of a too-large block,
>> and the block device on which the error occurred.
> 
> - how long is BDEVNAME_SIZE? Will it fit on the stack?

#define BDEVNAME_SIZE   32      /* Largest string for a blockdev
identifier */

~60 other users in md, ext3, jbd, buffer.c, etc. place it on the stack...

> - Does it include thespace for \0?

bdevname calls disk_name which does snprintf(buf, BDEVNAME_SIZE, ...),
so yes.

-Eric

> I asume you copied other users, and the other users will do it right (or 
> at least not terribly wrong:), but I can't dig the code right now.
> 
>>  Honestly minix.fsck
>> doesn't handle the situation well either, so at this point I hesitate
>> to recommend it in the print.  :)
> 
> *g*

