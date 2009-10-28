Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbZJ1Qeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbZJ1Qeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 12:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbZJ1Qeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 12:34:36 -0400
Received: from smtp102.prem.mail.sp1.yahoo.com ([98.136.44.57]:47488 "HELO
	smtp102.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754646AbZJ1Qef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 12:34:35 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: 213JxFAVM1nX9psfsr1R6IgKD41M1fl5mAa11v.fgDKgRoT2WwLUA6ZyXp0.qZWvkspcLmZehfztfKsbmwxpEt7BD9NZMRefeClXQIMhjxWAQ..enE13ToSf.VLmD4x7H2tnlggZJz5NCRO8uwjY2xOZNl3LHJRYGd51d1Gj5js4c2LA1X8X9Y7h9XFS6HGtlOJnOiI7n5c.8SxIGIfo6ZtQg4asb1e3u9b23TKxX0wruUH.F_9HO6bmlElhfW3PqO6SKooOO14UGkePOGiv1tMat0jDiUkys7tnBa0_c6oMMGOmcF83fDGhICut9lbHJ_h7UQnF8hVyA20rR6oC7UsXBPM-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AE87292.20802@schaufler-ca.com>
Date: Wed, 28 Oct 2009 09:34:26 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, Jan Kara <jack@suse.cz>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       jamie@shareable.org
Subject: Re: symlinks with permissions
References: <20091025062953.GC1391@ucw.cz> <20091026163157.GB7233@duck.suse.cz> <20091026165729.GF23564@us.ibm.com> <20091026173629.GB16861@fieldses.org> <20091026174631.GD7233@duck.suse.cz> <1256579869.8576.7.camel@heimdal.trondhjem.org> <20091025093604.GA1501@ucw.cz> <m1zl7cb1c5.fsf@fess.ebiederm.org> <20091028081653.GA18290@elf.ucw.cz>
In-Reply-To: <20091028081653.GA18290@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Tue 2009-10-27 21:15:54, Eric W. Biederman wrote:
>   
>> Pavel Machek <pavel@ucw.cz> writes:
>>
>>     
>>> On Mon 2009-10-26 13:57:49, Trond Myklebust wrote:
>>>       
>>>> On Mon, 2009-10-26 at 18:46 +0100, Jan Kara wrote:
>>>>         
>>>>>   That's what I'd think as well but it does not as I've just learned and
>>>>> tested :) proc_pid_follow_link actually directly gives a dentry of the
>>>>> target file without checking permissions on the way.
>>>>>           
>>> It is weider. That symlink even has permissions. Those are not
>>> checked, either.
>>>  
>>>       
>>>> I seem to remember that is deliberate, the point being that a symlink
>>>> in /proc/*/fd/ may contain a path that refers to a private namespace.
>>>>         
>>> Well, it is unexpected and mild security hole.
>>>       
>> /proc/<pid>/fd is only viewable by the owner of the process or by
>> someone with CAP_DAC_OVERRIDE.  So there appears to be no security
>> hole exploitable by people who don't have the file open.
>>     
>
> Please see bugtraq discussion at
> http://seclists.org/bugtraq/2009/Oct/179 .
>
> (In short, you get read-only fd, and you can upgrade it to read-write
> fd. Yes, you are the owner of the process, but you are not owner of
> the file the fd refers to.)
>
>   
>>> Part of the problem is that even  if you have read-only
>>> filedescriptor, you can upgrade it to read-write, even if path is
>>> inaccessible to you.
>>>
>>> So if someone passes you read-only filedescriptor, you can still write
>>> to it.
>>>       
>> Openly if you actually have permission to open the file again.  The actual
>> permissions on the file should not be ignored.
>>     
>
> The actual permissions of the file are not ignored, but permissions of
> the containing directory _are_. If there's 666 file in 700 directory,
> you can reopen it read-write, in violation of directory's 700
> permissions.
> 									Pavel
>   

There is no security violation here. Consider the case where
the file is unlinked after it is opened. What directory permissions
would matter in that case? Or what about the case where the file
has a link count of 2, say /a/foo and /b/ish are hard links. If
/a is 777 and /b is 700 what would your position be regarding
the file descriptor obtained by opening /b/ish? The path name is
an ethereal convenience and once traversed has no bearing on the
security state of the object. You need to change the semantics
of Linux (and Unix) file systems for your concern to make any
sense at all.

