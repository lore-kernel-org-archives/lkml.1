Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbYAGKel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbYAGKel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 05:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYAGKed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 05:34:33 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51305 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYAGKec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 05:34:32 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Tejun Heo <htejun@gmail.com>, Gabor Gombas <gombasg@sztaki.hu>,
       Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
References: <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com>
	<20080102151642.GA7273@boogie.lpds.sztaki.hu>
	<20080105075039.GF27894@ZenIV.linux.org.uk>
	<477F9481.2040505@gmail.com>
	<20080105194510.GK27894@ZenIV.linux.org.uk>
	<478037F8.8020103@gmail.com> <47819079.3000606@gmail.com>
	<m1abnikpuz.fsf@ebiederm.dsl.xmission.com>
	<4781EE20.6070701@gmail.com> <4781EE5D.1000105@gmail.com>
	<20080107092256.GX27894@ZenIV.linux.org.uk>
Date: Mon, 07 Jan 2008 03:33:38 -0700
In-Reply-To: <20080107092256.GX27894@ZenIV.linux.org.uk> (Al Viro's message of
	"Mon, 7 Jan 2008 09:22:56 +0000")
Message-ID: <m1myrhkjr1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Mon, Jan 07, 2008 at 06:18:21PM +0900, Tejun Heo wrote:
>> Tejun Heo wrote:
>> > Eric W. Biederman wrote:
>> >>> That said, the mechanism is a bit too fragile.  sysfs currently ensures
>> >>> that dentry/inode point to the associated sysfs_dirent.  This is mainly
>> >>> remanent of conversion from previous VFS based implementation.  I think
>> >>> the right thing to do here is to make sysfs behave like other proper
>> >>> distributed filesystems using d_revalidate.
>> >> Huh?  We still need something like sysfs_get_dentry to find the dentries
>> >> for the rename or move operation.  So we can call d_move.  
>> > 
>> > Ah... right.  Thanks.  :-)
>> 
>> On the second thought, can't those too be dealt with d_revalidate?
>
> FVO "dealt with" as pleasant and efficient as using coarse whetstone
> to deal with caries.

Or to say it another way.  The linux VFS requires dentries to be
preserved and used as long as we can.  dropping them early causes
some weird nasties to show up, in particular it totally messes up
mounting other filesystems on top.

Eric
