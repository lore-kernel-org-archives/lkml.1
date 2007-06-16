Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbXFPILw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbXFPILw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 04:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbXFPILj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 04:11:39 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:41098
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514AbXFPILh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 04:11:37 -0400
Message-ID: <46739B2C.4080606@hawkeye.stone.uk.eu.org>
Date: Sat, 16 Jun 2007 09:11:24 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: alan <alan@clueserver.org>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org>
In-Reply-To: <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

alan wrote:
> On Fri, 15 Jun 2007, H. Peter Anvin wrote:
>> This is one of those things that seems like a good idea, but frequently
>> ends up short.  Part of the problem is that "whenever you modify a file"
>> is ill-defined, or rather, if you were to take the literal meaning of it
>> you'd end up with an unmanageable number of revisions.
> 
> And no drive space.
>

One of the key points of the implementation would have to be the ability
to delete old revisions without affecting the subsequent revisions. This
would allow people to keep the number of revisions down.

Also if each revision is in effect a patch on the last revision it could
cut down the disk space required to store them, or if that takes to long
to read a file then have every tenth version (0,10,20,30...not the tenth
versions I know but easier to read) as a full version of the file which
all future versions are changed off.

>> Furthermore, it turns out that often relationships between files are
>> more important.
> 
> And there are files that are not important at all.
> 
> Would you save every temp file?  To be meaningful you would need to know
> the process they were tied to in many cases.

I hadn't considered that but I did think that you could remove the old
revisions of a file at some configurable time after. This would allow
recovery in case of accidental deletion but should keep the disk space
usage down.

>> Thus, in the end it turns out that this stuff is better handled by
>> explicit version-control systems (which require explicit operations to
>> manage revisions) and atomic snapshots (for backup.)

Possibly but if I use it to manage my entire system (ie as a package
manager) then the system would likely explode if I tryed to update or
remove a key package whilst the system was running. With the kernel
involved then the process could be much smoother.

> ZFS is the cool new thing in that space.  Too bad the license makes it
> hard to incorporate it into the kernel.  (I am one of those people that
> believe that Linux should support EVERY file system, no matter how old
> or obscure.)


