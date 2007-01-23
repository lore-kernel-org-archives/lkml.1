Return-Path: <linux-kernel-owner+w=401wt.eu-S965439AbXAWTGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965439AbXAWTGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 14:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965436AbXAWTGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 14:06:37 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:43317 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965439AbXAWTGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 14:06:36 -0500
X-Greylist: delayed 64395 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jan 2007 14:06:36 EST
Date: Tue, 23 Jan 2007 11:06:31 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Michael Noisternig <mnoist@cosy.sbg.ac.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: configfs: return value for drop_item()/make_item()?
Message-ID: <20070123190631.GH9422@ca-server1.us.oracle.com>
Mail-Followup-To: Michael Noisternig <mnoist@cosy.sbg.ac.at>,
	linux-kernel@vger.kernel.org
References: <45AF6D0C.8020600@cosy.sbg.ac.at> <20070118221249.GO27360@ca-server1.us.oracle.com> <45B4AF98.2080407@cosy.sbg.ac.at> <20070123011316.GC9422@ca-server1.us.oracle.com> <45B61287.1060206@cosy.sbg.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B61287.1060206@cosy.sbg.ac.at>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 02:49:59PM +0100, Michael Noisternig wrote:
> Sorry, I wasn't clear. I meant that it's not possible to let the user 
> create the parent directory via mkdir(2) within sysfs. I.e.
> # mkdir object  <-- create object/, configfs only
> # ls object
> type
> # echo b > object/type  <-- create b/, sysfs only
> # ls object
> type
> b/
> I cannot have both, sysfs and configfs functionality, within the same 
> module configuration file system tree.

	No, you can't have sysfs and configfs functionality in the same
exact portion of the tree.  But you can use both sysfs and configfs at
the same time in your driver.  The different parts will appear in the
different trees.  Up to you.

> 1. Is there any guarantee that strings passed to struct 
> configfs_item_operations->store_attribute are 0-terminated? If not, 
> there's not only potential for buffer overflows, but there already is - 
> in configfs_example.c, using simple_strtoul().

	There is no guarantee, but that's a bug.  The attribute handling
code came from sysfs.  I assume the initial assumption was that since
you can only copy a page, it's OK.  Clearly not the case.  sysfs fixed
this in October (commit 035ed7a49447bc8e15d4d9316fc6a359b2d94333).  I'll
be porting that over.  Thanks for noticing!

> 2. A minor one: I realize that the CONFIGFS_ITEM_NAME_LEN value of 20 is 
> taken over from sysfs, but in configfs a config_group now has 68 bytes 
> of size, and assuming that many times one would simply kmalloc a simple 
> struct config_group (without extending it) this would result in a waste 
> of 60 bytes per malloc. Do you want to keep that #define or reduce it to 
> 16? Just a thought...

	Hmm, interesting.  I'll look at that as well.

Joel

-- 

Life's Little Instruction Book #511

	"Call your mother."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
