Return-Path: <linux-kernel-owner+w=401wt.eu-S1760707AbXJMRmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760707AbXJMRmj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 13:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756694AbXJMRmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 13:42:31 -0400
Received: from usul.saidi.cx ([204.11.33.34]:59673 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756649AbXJMRma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 13:42:30 -0400
Message-ID: <47110379.10000@overt.org>
Date: Sat, 13 Oct 2007 10:42:17 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hiddev: Add 32bit ioctl compatibilty
References: <47100864.2090208@overt.org> <20071013000221.GC8181@ftp.linux.org.uk>
In-Reply-To: <20071013000221.GC8181@ftp.linux.org.uk>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
>>
>> +static long hiddev_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>> +{
>> +	struct inode *inode = file->f_path.dentry->d_inode;
>> +	return hiddev_ioctl(inode, file, cmd, compat_ptr(arg));
>> +}
> 
> Just how many instances of that sucker do we need?  It's nothing but
> 
>      struct inode *inode = file->f_path.dentry->d_inode;
>      return file->f_op->ioctl(inode, file, cmd, compat_ptr(arg));
> 

So, I don't actually know what you're looking for, but of the 140 occasions
that .compat_ioctl is implemented in Linus' tree, I can't find another one
that actually uses this form. So, writing a shared implementation doesn't pick
off any low hanging fruit. Now, it's possible that some of the other implementations
could be reduced to this form - but for now, it seems the answer to your question
is 'one' in either case. :-)

--phil
