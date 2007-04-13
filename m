Return-Path: <linux-kernel-owner+w=401wt.eu-S1751806AbXDMErV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbXDMErV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 00:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXDMErV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 00:47:21 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44759 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbXDMErU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 00:47:20 -0400
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
Date: Thu, 12 Apr 2007 22:45:33 -0600
In-Reply-To: <20070412203208.GG27772@sergelap.austin.ibm.com> (Serge
	E. Hallyn's message of "Thu, 12 Apr 2007 15:32:08 -0500")
Message-ID: <m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Quoting Miklos Szeredi (miklos@szeredi.hu):
>> From: Miklos Szeredi <mszeredi@suse.cz>
>> 
>> If CLONE_NEWNS and CLONE_NEWNS_USERMNT are given to clone(2) or
>> unshare(2), then allow user mounts within the new namespace.
>> 
>> This is not flexible enough, because user mounts can't be enabled for
>> the initial namespace.
>> 
>> The remaining clone bits also getting dangerously few...
>> 
>> Alternatives are:
>> 
>>   - prctl() flag
>>   - setting through the containers filesystem
>
> Sorry, I know I had mentioned it, but this is definately my least
> favorite approach.
>
> Curious whether are any other suggestions/opinions from the containers
> list?

Given the existence of shared subtrees allowing/denying this at the mount
namespace level is silly and wrong.

If we need more than just the filesystem permission checks can we
make it a mount flag settable with mount and remount that allows
non-privileged users the ability to create mount points under it
in directories they have full read/write access to.

I don't like the use of clone flags for this purpose but in this
case the shared subtress are a much more fundamental reasons for not
doing this at the namespace level.

Eric
