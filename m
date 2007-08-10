Return-Path: <linux-kernel-owner+w=401wt.eu-S934488AbXHJJyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934488AbXHJJyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 05:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760234AbXHJJyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 05:54:25 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:42912 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759756AbXHJJyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 05:54:24 -0400
Date: Fri, 10 Aug 2007 13:53:02 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       dipankar@in.ibm.com
Subject: Re: + sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch added to -mm tree
Message-ID: <20070810095301.GA6726@localhost.sw.ru>
References: <200708100141.l7A1ftnd029565@imap1.linux-foundation.org> <20070810081810.GB6670@localhost.sw.ru> <m1fy2rzqn7.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1fy2rzqn7.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 03:26:52AM -0600, Eric W. Biederman wrote:
> Alexey Dobriyan <adobriyan@sw.ru> writes:
> 
> >> @@ -1124,7 +1118,6 @@ static struct ctl_table fs_table[] = {
> >>  		.proc_handler	= &proc_dointvec,
> >>  	},
> >>  	{
> >> -		.ctl_name	= FS_NRFILE,
> >>  		.procname	= "file-nr",
> >>  		.data		= &files_stat,
> >>  		.maxlen		= 3*sizeof(int),
> >
> > Why? It will work just fine through default sysctl(2) writeback.
> 
> 
> Well write doesn't happen.  But even more so proc_nr_files() dynamically
> generates files_stat.nr_files.  That doesn't happen on the generic
> sysctl path, and thus it's broken.

I see now, thanks. CC'ing Dipankar who probably want to fix this.
Dipankar, fs.file-nr always contains stale data in nr_files field unless
you regenerate it by reading /proc/sys/fs/file-nr :)

> Yes.  I'm being picky, because at some point in the past before
> that was a per cpu variable the code worked, and won't look broken
> now unless you examine the contents of the data.

More than year passed, nobody noticed until now, probably FS_NRFILE
should go.

