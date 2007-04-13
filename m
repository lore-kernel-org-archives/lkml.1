Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbXDMOXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbXDMOXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 10:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbXDMOXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 10:23:46 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42169 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbXDMOXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 10:23:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, containers@lists.osdl.org,
       viro@ftp.linux.org.uk, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 05/10] add "permit user mounts in new namespace" clone flag
References: <20070412164541.580374744@szeredi.hu>
	<20070412164620.588752236@szeredi.hu>
	<20070412203208.GG27772@sergelap.austin.ibm.com>
	<m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com>
	<E1HcFx1-0001Zr-00@dorka.pomaz.szeredi.hu>
	<20070413134732.GB1483@sergelap.austin.ibm.com>
Date: Fri, 13 Apr 2007 08:22:10 -0600
In-Reply-To: <20070413134732.GB1483@sergelap.austin.ibm.com> (Serge
	E. Hallyn's message of "Fri, 13 Apr 2007 08:47:33 -0500")
Message-ID: <m17isgpd65.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Quoting Miklos Szeredi (miklos@szeredi.hu):
>> > Given the existence of shared subtrees allowing/denying this at the mount
>> > namespace level is silly and wrong.
>> > 
>> > If we need more than just the filesystem permission checks can we
>> > make it a mount flag settable with mount and remount that allows
>> > non-privileged users the ability to create mount points under it
>> > in directories they have full read/write access to.
>> 
>> OK, that makes sense.
>> 
>> > I don't like the use of clone flags for this purpose but in this
>> > case the shared subtress are a much more fundamental reasons for not
>> > doing this at the namespace level.
>> 
>> I'll drop the clone flag, and add a mount flag instead.
>> 
>> Thanks,
>> Miklos
>
> Makes sense, so then on login pam has to spawn a new user namespace and
> construct a root fs with no shared subtrees and with the
> user-mounts-allowed flag specified?

I was expecting the usage in the normal case to be the Al Viro style
with shared subtrees setup for each user, with the shared subtree marked
with user-mounts-allowed.  Then on login pam would unshare the namespace
and restrict the user to their specific portion of the shared subtree.

If you don't use multiple mount namespaces all of the users have to
agree on what they want the non-privileged part of the namespace
to look like.

If you don't use shared subtrees you have to deal with all of the
joys of implementing enter, or else multiple logins from the same user
have problems.

Eric
