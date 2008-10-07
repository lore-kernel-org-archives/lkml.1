Return-Path: <linux-kernel-owner+w=401wt.eu-S1758396AbYJGVYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbYJGVYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756544AbYJGVY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:24:29 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41931 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756095AbYJGVY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:24:28 -0400
Subject: Re: [PATCH 2/3] sysfs: Fix and sysfs_mv_dir by using lock_rename.
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>
In-Reply-To: <m1vdw465lm.fsf_-_@frodo.ebiederm.org>
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>
	 <48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org>
	 <20081003101331.GH28946@ZenIV.linux.org.uk>
	 <20081005053236.GA9472@kroah.com> <m1bpxwajyy.fsf@frodo.ebiederm.org>
	 <m163o47kc5.fsf_-_@frodo.ebiederm.org>
	 <m11vys7k92.fsf_-_@frodo.ebiederm.org>
	 <m1vdw465lm.fsf_-_@frodo.ebiederm.org>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 14:21:09 -0700
Message-Id: <1223414469.31401.18.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-07 at 03:51 -0700, Eric W. Biederman wrote:
> sysfs_mv_dir picks an arbitrary mutex lock ordering and busy waits
> until it can grab the inode mutexes in that order.  This can dead lock
> on UP systems.
> 
> Instead use the generic lock_rename that guarantees we grab parent
> directories before child directories, so there is not need to spin and
> no chance of deadlock.

This is a vast improvement over what was there before.  Nice!

-- Dave

