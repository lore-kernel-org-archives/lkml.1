Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbXICBGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbXICBGi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 21:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbXICBGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 21:06:30 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45239 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbXICBG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 21:06:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <htejun@gmail.com>
Cc: Greg K-H <greg@kroah.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: regarding sysfs/kobject separation
References: <46DABD6A.2030708@gmail.com>
Date: Sun, 02 Sep 2007 19:06:09 -0600
In-Reply-To: <46DABD6A.2030708@gmail.com> (Tejun Heo's message of "Sun, 02 Sep
	2007 22:40:58 +0900")
Message-ID: <m1veasy2v2.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> writes:

> * Automatic symlink handling.  Symlink names can be formatted with the
> name of its target.  e.g. if the symlink name is specified as
> "link-%1:%0" and points to "devices/mybus0/mydev0", its name becomes
> "link-mybus0-mydev0" && the symlink will be automatically renamed when
> the target node or one of its ancestor is moved or renamed.  The symlink
> is also plugged and removed together with its target.  So, once created,
> the user doesn't have to care about the symlink.  sysfs will take care
> of it.

Sounds nice.

> * I think most of the changes wouldn't hinder implementation of tagged
> nodes.  In fact, most of the new rename logic which handles symlink
> rename together is taken from tagged node implementation, so with some
> luck it should be easier to support tagged nodes.

Hopefully.

> *** Future plans.
>
> * Move uevent support over to sysfs and bridging the current users.
> This makes sense because sysfs hierarchy is all that userland can see
> and sysfs users which don't use kobject also needs uevent support.

This could have an interesting interaction with the namespace work.
I think my current implementation only makes these events visible
in the initial network namespace.  But that should change.

Eric
