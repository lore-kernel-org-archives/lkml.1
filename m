Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbZJ1LZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbZJ1LZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 07:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZJ1LZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 07:25:31 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53076 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbZJ1LZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 07:25:29 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, Jan Kara <jack@suse.cz>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       jamie@shareable.org
Subject: Re: symlinks with permissions
References: <20091025062953.GC1391@ucw.cz>
	<20091026163157.GB7233@duck.suse.cz>
	<20091026165729.GF23564@us.ibm.com>
	<20091026173629.GB16861@fieldses.org>
	<20091026174631.GD7233@duck.suse.cz>
	<1256579869.8576.7.camel@heimdal.trondhjem.org>
	<20091025093604.GA1501@ucw.cz> <m1zl7cb1c5.fsf@fess.ebiederm.org>
	<20091028081653.GA18290@elf.ucw.cz>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 28 Oct 2009 04:25:23 -0700
In-Reply-To: <20091028081653.GA18290@elf.ucw.cz> (Pavel Machek's message of "Wed\, 28 Oct 2009 09\:16\:53 +0100")
Message-ID: <m1k4yfkbfg.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> On Tue 2009-10-27 21:15:54, Eric W. Biederman wrote:
>> Pavel Machek <pavel@ucw.cz> writes:
>> 
>> > On Mon 2009-10-26 13:57:49, Trond Myklebust wrote:
>> >> On Mon, 2009-10-26 at 18:46 +0100, Jan Kara wrote:
>> >> >   That's what I'd think as well but it does not as I've just learned and
>> >> > tested :) proc_pid_follow_link actually directly gives a dentry of the
>> >> > target file without checking permissions on the way.
>> >
>> > It is weider. That symlink even has permissions. Those are not
>> > checked, either.
>> >  
>> >> I seem to remember that is deliberate, the point being that a symlink
>> >> in /proc/*/fd/ may contain a path that refers to a private namespace.
>> >
>> > Well, it is unexpected and mild security hole.
>> 
>> /proc/<pid>/fd is only viewable by the owner of the process or by
>> someone with CAP_DAC_OVERRIDE.  So there appears to be no security
>> hole exploitable by people who don't have the file open.
>
> Please see bugtraq discussion at
> http://seclists.org/bugtraq/2009/Oct/179 .
>
> (In short, you get read-only fd, and you can upgrade it to read-write
> fd. Yes, you are the owner of the process, but you are not owner of
> the file the fd refers to.)

Assuming you have permission to open it read-write.

>> > Part of the problem is that even  if you have read-only
>> > filedescriptor, you can upgrade it to read-write, even if path is
>> > inaccessible to you.
>> >
>> > So if someone passes you read-only filedescriptor, you can still write
>> > to it.
>> 
>> Openly if you actually have permission to open the file again.  The actual
>> permissions on the file should not be ignored.
>
> The actual permissions of the file are not ignored, but permissions of
> the containing directory _are_. If there's 666 file in 700 directory,
> you can reopen it read-write, in violation of directory's 700
> permissions.

I can see how all of this can come as a surprise.  However I don't see
how any coder who is taking security seriously and being paranoid about
security would actually write code that would have a problem with this.

Do you know of any cases where this difference matters in practice?

It looks to me like it has been this way for better than a decade
without problems so there is no point in changing it now.  

Eric
