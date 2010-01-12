Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565Ab0ALApK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab0ALApK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445Ab0ALApJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:45:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:32881 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab0ALApI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:45:08 -0500
Message-ID: <4B4BC683.7060508@kernel.org>
Date: Tue, 12 Jan 2010 09:46:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 3/7] sysfs: Keep an nlink count on sysfs directories.
References: <m1d41g9z3q.fsf@fess.ebiederm.org> <1263241315-19499-3-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1263241315-19499-3-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Jan 2010 00:44:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/12/2010 05:21 AM, Eric W. Biederman wrote:
> On large directories sysfs_count_nlinks can be a significant
> bottleneck, so keep a count in sysfs_dirent.

I was about to suggest changing s_flags to ushort too.  Hmmm... adding
a new field to sysfs_dirent somewhat worries me but this doesn't add
to the size of the structure.  How significant bottlenect are we
talking about?

> If we exceed the maximum number of directory entries we can store
> return nlink of 1.  An nlink of 1 matches what reiserfs does in this
> case, and it let's find and similar utlities know that we have a the
> directory nlink can not be used for optimization purposes.

Hmmm... what's the limit on reiserfs?  Is it 64k too?

Thanks.

-- 
tejun
