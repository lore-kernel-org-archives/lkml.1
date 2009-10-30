Return-Path: <linux-kernel-owner+w=401wt.eu-S933082AbZJ3XDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082AbZJ3XDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 19:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbZJ3XDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 19:03:44 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60162 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933008AbZJ3XDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 19:03:43 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, Jan Kara <jack@suse.cz>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       jamie@shareable.org
Subject: Re: symlinks with permissions
References: <20091026174631.GD7233@duck.suse.cz>
	<1256579869.8576.7.camel@heimdal.trondhjem.org>
	<20091025093604.GA1501@ucw.cz> <m1zl7cb1c5.fsf@fess.ebiederm.org>
	<20091028081653.GA18290@elf.ucw.cz> <m1k4yfkbfg.fsf@fess.ebiederm.org>
	<20091028210323.GA4159@elf.ucw.cz> <m1hbtj7xgj.fsf@fess.ebiederm.org>
	<20091029110344.GA1517@ucw.cz> <m1d4466uel.fsf@fess.ebiederm.org>
	<20091030183559.GF7008@elf.ucw.cz>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 30 Oct 2009 16:03:36 -0700
In-Reply-To: <20091030183559.GF7008@elf.ucw.cz> (Pavel Machek's message of "Fri\, 30 Oct 2009 19\:35\:59 +0100")
Message-ID: <m1ocnomqlz.fsf@fess.ebiederm.org>
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

>> >> I certainly am not interested in debugging or maintaining the stacking
>> >> inode code that would be necessary to close this theoretical corner
>> >> case.  There are much more real bugs that need attention.
>> >
>> > But if we can get trivial 10-liner, that should be acceptable, right?
>> 
>> How many linux shell scripts and other applications that use /dev/fd/N
>> or /proc/self/fd/N will you be breaking?
>
> Zero. (Well unless someone is exploiting it in wild).

There are other differences like different offsets etc that may matter.

>> Closing a theoretical security hole at the expense of breaking real
>> applications is a show stopper.
>
> I don't plan to remove /proc/*/fd; but I would like it to behave like
> dup().
>
> (I still hope some security team does work for me :-).

Seriously turning this into dup is about 20 lines of code in follow
link.  Just look at the open intent in the nameidata.  nfs should
have an exampled of using the open intent somewhere.

I bet you will get a lot more traction and discussion if you write
a basic mostly working version of the patch.

Eric
