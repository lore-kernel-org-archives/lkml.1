Return-Path: <linux-kernel-owner+w=401wt.eu-S936395AbZLQEQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936395AbZLQEQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:16:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936379AbZLQEPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:15:41 -0500
Received: from cantor.suse.de ([195.135.220.2]:56294 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936374AbZLQEPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:15:35 -0500
Date: Wed, 16 Dec 2009 20:15:34 -0800
From: Greg KH <gregkh@suse.de>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Csaba Henk <csaba@gluster.com>,
       Miklos Szeredi <mszeredi@suse.cz>, Harshavardhana <harsha@gluster.com>
Subject: Re: [04/18] fuse: reject O_DIRECT flag also in fuse_create
Message-ID: <20091217041534.GA26509@suse.de>
References: <20091217004707.472856791@mini.kroah.org> <4B298B2A.5010900@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B298B2A.5010900@caviumnetworks.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 05:36:42PM -0800, David Daney wrote:
> Greg KH wrote:
>> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
>>
>> ------------------
>> From: Csaba Henk <csaba@gluster.com>
>>
>> commit 1b7323965a8c6eee9dc4e345a7ae4bff1dc93149 upstream.
>>
>> The comment in fuse_open about O_DIRECT:
>>
>>   "VFS checks this, but only _after_ ->open()"
>>
>> also holds for fuse_create, however, the same kind of check was missing there.
>>
>> As an impact of this bug, open(newfile, O_RDWR|O_CREAT|O_DIRECT) fails, but a
>> stub newfile will remain if the fuse server handled the implied FUSE_CREATE
>> request appropriately.
>>
>> Other impact: in the above situation ima_file_free() will complain to open/free
>> imbalance if CONFIG_IMA is set.
>>
>> Signed-off-by: Csaba Henk <csaba@gluster.com>
>> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>> Cc: Harshavardhana <harsha@gluster.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>>
>> ---
>>  fs/fuse/dir.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> --- a/fs/fuse/dir.c
>> +++ b/fs/fuse/dir.c
>> @@ -401,6 +401,9 @@ static int fuse_create_open(struct inode
>>  	if (flags & O_DIRECT)
>>  		return -EINVAL;
>>  +	if (flags & O_DIRECT)
>> +		return -EINVAL;
>> +
>
> I must be missing something.  The added part seems to be identical to the 
> lines just above.
>
> Forgive me if I am totally misreading the diff.

Oops, you are right, this was already included in the last .27 release,
my mistake.  I've now deleted it from the .27 queue.

thanks,

greg k-h
