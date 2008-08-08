Return-Path: <linux-kernel-owner+w=401wt.eu-S1764834AbYHHWjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764834AbYHHWjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYHHWjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:39:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50404 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043AbYHHWjb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:39:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 1/4] checkpoint-restart: general infrastructure
Date: Sat, 9 Aug 2008 00:39:19 +0200
User-Agent: KMail/1.9.9
Cc: containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>
References: <20080807224033.FFB3A2C1@kernel> <200808090013.41999.arnd@arndb.de> <1218234411.19082.58.camel@nimitz>
In-Reply-To: <1218234411.19082.58.camel@nimitz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808090039.20289.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/GsBV7kPivT1hmxkOmRpNXeQW8qgiWhz/Ky6d
 YdQULA892biHlccMS05jlog99RekVnZ1CDnzqq5T4rgtoGRHM8
 hD9MEYSdwHZVBZD5KEX1g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 August 2008, Dave Hansen wrote:
> On Sat, 2008-08-09 at 00:13 +0200, Arnd Bergmann wrote:

> > Maybe you can invert the logic and let the new syscalls create a file
> > descriptor, and then have user space read or splice the checkpoint
> > data from it, and restore it by writing to the file descriptor.
> > It's probably easy to do using anon_inode_getfd() and would solve this
> > problem, but at the same time make checkpointing the current thread
> > hard if not impossible.
> 
> Yeah, it does seem kinda backwards.  But, instead of even having to
> worry about the anon_inode stuff, why don't we just put it in a fs like
> everything else?  checkpointfs!

Well, anon_inodes are really easy to use and have replaced some of the
simple non-mountable file systems in the kernel.

checkpointfs sounds interesting and I guess in a plan9 world of fairies
and fantasy, you should be able to create a checkpoint of your system using
'tar czf - /proc/', but I'm not sure it helps here.

The main problem I see with that would be atomicity: If you want multiple
processes to keep interacting with each other, you need to save them at
the same point in time, which gets harder as you split your interface into
more than a single file descriptor.

	Arnd <><
