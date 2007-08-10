Return-Path: <linux-kernel-owner+w=401wt.eu-S933904AbXHJJ2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904AbXHJJ2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 05:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757995AbXHJJ2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 05:28:00 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60008 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757875AbXHJJ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 05:27:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: + sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch added to -mm tree
References: <200708100141.l7A1ftnd029565@imap1.linux-foundation.org>
	<20070810081810.GB6670@localhost.sw.ru>
Date: Fri, 10 Aug 2007 03:26:52 -0600
In-Reply-To: <20070810081810.GB6670@localhost.sw.ru> (Alexey Dobriyan's
	message of "Fri, 10 Aug 2007 12:18:10 +0400")
Message-ID: <m1fy2rzqn7.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@sw.ru> writes:

>> @@ -1124,7 +1118,6 @@ static struct ctl_table fs_table[] = {
>>  		.proc_handler	= &proc_dointvec,
>>  	},
>>  	{
>> -		.ctl_name	= FS_NRFILE,
>>  		.procname	= "file-nr",
>>  		.data		= &files_stat,
>>  		.maxlen		= 3*sizeof(int),
>
> Why? It will work just fine through default sysctl(2) writeback.


Well write doesn't happen.  But even more so proc_nr_files() dynamically
generates files_stat.nr_files.  That doesn't happen on the generic
sysctl path, and thus it's broken.

Yes.  I'm being picky, because at some point in the past before
that was a per cpu variable the code worked, and won't look broken
now unless you examine the contents of the data.

Eric
