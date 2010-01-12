Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664Ab0ALBPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0ALBPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 20:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067Ab0ALBPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 20:15:07 -0500
Received: from kanga.kvack.org ([205.233.56.17]:56411 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440Ab0ALBPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 20:15:04 -0500
Date: Mon, 11 Jan 2010 19:53:08 -0500
From: Benjamin LaHaise <bcrl@lhnet.ca>
To: Tejun Heo <tj@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 3/7] sysfs: Keep an nlink count on sysfs directories.
Message-ID: <20100112005308.GL5524@kvack.org>
References: <m1d41g9z3q.fsf@fess.ebiederm.org> <1263241315-19499-3-git-send-email-ebiederm@xmission.com> <4B4BC683.7060508@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4BC683.7060508@kernel.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 09:46:59AM +0900, Tejun Heo wrote:
> Hello,
> 
> On 01/12/2010 05:21 AM, Eric W. Biederman wrote:
> > On large directories sysfs_count_nlinks can be a significant
> > bottleneck, so keep a count in sysfs_dirent.
> 
> I was about to suggest changing s_flags to ushort too.  Hmmm... adding
> a new field to sysfs_dirent somewhat worries me but this doesn't add
> to the size of the structure.  How significant bottlenect are we
> talking about?

100,000 entries in a sysfs directory is a requirement for network devices.

> > If we exceed the maximum number of directory entries we can store
> > return nlink of 1.  An nlink of 1 matches what reiserfs does in this
> > case, and it let's find and similar utlities know that we have a the
> > directory nlink can not be used for optimization purposes.
> 
> Hmmm... what's the limit on reiserfs?  Is it 64k too?

64k is too small.  10 gig interfaces can currently service 50-100k users, 
each of which requires their own network device.

		-ben
