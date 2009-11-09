Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZKIDa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZKIDa4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 22:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbZKIDa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 22:30:56 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:53281 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbZKIDaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 22:30:55 -0500
To: Jeff Layton <jlayton@redhat.com>
Cc: Jamie Lokier <jamie@shareable.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
       adobriyan@gmail.com, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH] proc: revalidate dentry returned by proc_pid_follow_link
References: <1257513594-31071-1-git-send-email-jlayton@redhat.com>
	<20091106203601.GD27751@shareable.org>
	<20091106160612.4cd05e76@tlielax.poochiereds.net>
	<m17hu1miea.fsf@fess.ebiederm.org>
	<20091108201237.79af5cac@tupile.poochiereds.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 08 Nov 2009 19:30:55 -0800
In-Reply-To: <20091108201237.79af5cac@tupile.poochiereds.net> (Jeff Layton's message of "Sun\, 8 Nov 2009 20\:12\:37 -0500")
Message-ID: <m1hbt49xxs.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton <jlayton@redhat.com> writes:

>> Hmm.  Looking at the code I get the impression that a file bind mount
>> will have exactly the same problem.
>> 
>> Can you confirm.
>> 
>> If file bind mounts also have this problem a bugfix to to just
>> proc seems questionable.
>> 
>
> I'm not sure I understand what you mean by "file bind mount". Is that
> something like mounting with "-o loop" ?

# cd /tmp
# echo foo > foo
# echo bar > bar
# mount --bind foo bar
# cat bar
foo
#

> I'm not at all opposed to fixing this in a more broad fashion, but as
> best I can tell, the only place that LAST_BIND is used is in procfs.

proc does appear to be the only user of LAST_BIND.  With a file bind
mount we can get to the same ok: label without a revalidate.  The
difference is that we came from __follow_mount instead of follow_link.

At least that is how I read the code.

Eric
