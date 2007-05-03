Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbXECLXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbXECLXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 07:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbXECLXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 07:23:23 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1950 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbXECLXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 07:23:22 -0400
From: "Miquel van Smoorenburg" <mikevs@xs4all.net>
To: adilger@clusterfs.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] fallocate system call
X-Newsgroups: lists.linux.kernel
In-Reply-To: <20070503103425.GE6220@schatzie.adilger.int>
References: <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070430004702.GM32602149@melbourne.sgi.com> <20070430052559.GA13145@tuatara.stupidest.org> <20070502125312.GA5845@amitarora.in.ibm.com>
Organization: 
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1HjZOa-0003iJ-PX@n2o.xs4all.nl>
Date: Thu, 03 May 2007 13:22:48 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20070503103425.GE6220@schatzie.adilger.int> you write:
>On May 02, 2007  18:23 +0530, Amit K. Arora wrote:
>> On Sun, Apr 29, 2007 at 10:25:59PM -0700, Chris Wedgwood wrote:
>> > On Mon, Apr 30, 2007 at 10:47:02AM +1000, David Chinner wrote:
>> > 
>> > > For FA_ALLOCATE, it's supposed to change the file size if we
>> > > allocate past EOF, right?
>> > 
>> > I would argue no.  Use truncate for that.
>> 
>> The patch I posted for ext4 *does* change the filesize after
>> preallocation, if required (i.e. when preallocation is after EOF).
>> I may have to change that, if we decide on not doing this.
>
>I think I'd agree - it may be useful to allow preallocation beyond EOF
>for some kinds of applications (e.g. PVR preallocating live TV in 10
>minute segments or something, but not knowing in advance how long the
>show will actually be recorded or the final encoded size).

I have an application (diablo dreader) where the header-info database
basically consists of ~40.000 files, one for each group (it's more
complicated that that, but never mind that now).

If you grow those files randomly by a few hundred bytes every update,
the filesystem gets hopelessly fragmented.

I'm using XFS with preallocation turned on, and biosize=18 (which
makes it preallocate in blocks of 256KB), and a homebrew patch that
leaves the preallocated space on disk preallocated even if the
file is closed .. and it helps enormously.

Mike.
