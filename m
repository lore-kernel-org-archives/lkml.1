Return-Path: <linux-kernel-owner+w=401wt.eu-S1751823AbZC0HEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbZC0HEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 03:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbZC0HEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 03:04:33 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:35007 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZC0HEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 03:04:31 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>, serue@us.ibm.com, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       linux-fsdevel@vger.kernel.org
Subject: Re: unprivileged mounts vs. rmdir (was: VFS, NFS security bug? ...)
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com>
	<20090311232356.GP13540@fieldses.org>
	<20090312161047.GA15209@us.ibm.com>
	<517f3f820903121321sf6d2014q8165b925d5d44db7@mail.gmail.com>
	<20090313175848.GB27891@fieldses.org>
	<cfd18e0f0903141220u66230ceer22ef0cc6aed1d046@mail.gmail.com>
	<f44001920903160716i488e3642o869f626a5c3327d0@mail.gmail.com>
	<20090316163611.GB10959@fieldses.org>
	<20090316170433.GA2996@us.ibm.com>
	<E1Llk5q-0000kd-IR@pomaz-ex.szeredi.hu> <20090326124338.GA1466@ucw.cz>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 27 Mar 2009 00:04:20 -0700
In-Reply-To: <20090326124338.GA1466@ucw.cz> (Pavel Machek's message of "Thu\, 26 Mar 2009 13\:43\:38 +0100")
Message-ID: <m163hvmop7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: pavel@ucw.cz, linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, bfields@fieldses.org, serue@us.ibm.com, miklos@szeredi.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> On Mon 2009-03-23 14:21:30, Miklos Szeredi wrote:
>> [CCs trimmed]
>> 
>> On Mon, 16 Mar 2009, Serge E. Hallyn wrote:
>> > Quoting J. Bruce Fields (bfields@fieldses.org):
>> > > special privilege, so don't consult filesystem permissions (do I have
>> > > that right?  What happened to the attempt to allow ordinary users to
>> > > mount?).
>> > 
>> > Well, they keep getting stalled because we don't have a good answer for
>> > what to do about the fact that an unprivileged user can make trees
>> > undeletable by pinning them with mounts.  (Miklos and Eric cc'd in case
>> > I didn't explain that well enough).
>> 
>> That's correct.
>> 
>> The best answer I can come up with is to allow rmdir/unlink to
>> automatically umount trees from their respective dentries.  Obviously
>> this can't be done for regular (privileged) mounts, which must keep
>> returning EBUSY in such situations.
>> 
>> But for unprivileged mounts I can't see any fundamental issue with
>> such an approach.
>> 
>> Does anyone see a problem with this?  Is there a better solution?
>
> Well... traditionally if you have an open file or cwd inside mounted
> tree... that blocks unmount, right?
>
> What will you do with processes that have open (deleted) files inside
> the mount? What about cwd?

That is a backwards understanding, of the problem.

Currently I can not delete my mount point if I have something mounted on it in another
mount namespace.

Generally lazy unmounts solve the deleted inodes problem, your were talking about.

Eric


