Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbZKSV4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbZKSV4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 16:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbZKSV4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 16:56:42 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:52100 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbZKSV4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 16:56:41 -0500
To: Pavel Machek <pavel@ucw.cz>
Cc: Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] procfs: make /proc style symlinks behave like "normal" symlinks
References: <1258638251-20034-1-git-send-email-jlayton@redhat.com>
	<m14ooq5tq3.fsf@fess.ebiederm.org>
	<20091119132833.30bc93a4@barsoom.rdu.redhat.com>
	<m1skca2vi3.fsf@fess.ebiederm.org>
	<20091119143555.7851953f@barsoom.rdu.redhat.com>
	<20091119213935.GA11212@elf.ucw.cz>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 19 Nov 2009 13:56:44 -0800
In-Reply-To: <20091119213935.GA11212@elf.ucw.cz> (Pavel Machek's message of "Thu\, 19 Nov 2009 22\:39\:35 +0100")
Message-ID: <m1vdh6uqjn.fsf@fess.ebiederm.org>
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

>> > Adding all of the short comings to followlink that readlink has is a problem,
>> > especially as followlink does much better now.
>> > 
>> > At a practical level I think your changes are much easier to exploit than
>> > Pavels contrived example.
>> > 
>> > I really don't have any problems with your first patch to proc to add the
>> > missing revalidate.
>> > 
>> 
>> Thanks, that makes sense. The raciness was evident once you pointed it
>> out, so I think you're correct that we can't take this approach.
>> 
>> Adding the missing revalidations is fine, but I don't believe that
>> helps to fix Pavel's issue. I'll go back and take a more careful look
>> at the suggestion that Miklos made and see whether it makes sense to
>> implement a new FS_* flag for this, and see what it'll take to fix
>> Pavel's issue.
>
> One posibility would be to make open(/proc/XX/fd/XX) behave like
> dup(). That should solve the NFS problems, too, no?

Not for bind mounts, and the revalidate in follow_mounts is a bug regardless.

Eric
