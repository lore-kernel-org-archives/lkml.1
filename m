Return-Path: <linux-kernel-owner+w=401wt.eu-S932814AbYGCHHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814AbYGCHHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbYGCG5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:48 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:31690 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608AbYGCDSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 23:18:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=j6anDSzbni1HIp3usUB+HFM9oVuFDxPn9YLixu8IU61Zt+OQUhNUwi6OcnbXkjAAcr
         8Ig5q8SS7mg3a9DU1P7yGQPz3qlN2mxGeGDJcJQoRxITFnvULREsnA82uMJJ6Xt8VkMo
         Nz1Z+mTe/4rOMm0RQeW7KXN7/Ar7HiB+0RTRI=
Message-ID: <486C4515.1070007@gmail.com>
Date: Thu, 03 Jul 2008 12:18:45 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Benjamin Thery <benjamin.thery@bull.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 06/11] sysfs: Implement sysfs tagged directory support.
References: <20080618170729.808539948@theryb.frec.bull.fr>	<20080618170731.002784342@theryb.frec.bull.fr>	<485F04E1.70204@gmail.com> <m1y74svtff.fsf@frodo.ebiederm.org>	<486706C9.9040303@gmail.com> <m18wwmsqdv.fsf@frodo.ebiederm.org>	<4869D314.5030403@gmail.com> <m1ej6enep7.fsf@frodo.ebiederm.org>	<486A0751.9080602@gmail.com> <m1wsk5hjm0.fsf@frodo.ebiederm.org>	<486AF4FA.8020805@gmail.com> <m1ej6d9c2r.fsf@frodo.ebiederm.org>	<486B060C.7030607@gmail.com> <m14p78s02q.fsf@frodo.ebiederm.org>
In-Reply-To: <m14p78s02q.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

Eric W. Biederman wrote:
>> If
>> changing the default function is too much of a hassle (and I'm sure it
>> would be), just add an extended version which takes @tag.  The current
>> implementation feels like it tried too hard to not add intermediate
>> interfaces and ended up shooting outside from the innermost layer.
> 
> It tried for something that was simple to use and that worked.
> 
> Also the way things work.  I have to use all of the intermediate layers
> and their calls to various functions.  So just passing a parameter through
> doesn't work to well.

There is rather large possibility that I'm just being dumb here
especially because I haven't reviewed the users of this facility, so all
the comments I'm making are from the POV of interfaces of sysfs and the
related layers.  I think I've made my concerns clear by now.  If you
still think the callbacks are the best way to go, please try to
enlighten me.  I really don't wanna be stopping something which is
better from ignorance.  Just give me some concrete examples or point me
to codes which show how and why the current interface is the best for
the users and switching isn't a good idea.

> It looks to me like the clean solution is move kobject_tag into
> kobj_type, and have it call some higher level function.
> 
> We also need to remove the maintenance disaster that is
> kobject_set_name from sysfs_rename_dir.  And push it into
> kobject_rename instead.  The error handling is harder in
> that case but otherwise we should be in good shape.

Heh... I personally think kobject layer as a whole should just be hidden
under the cabinet of device driver model but I'm having difficult time
convincing other people of it.  Anyways, fully agree the interaction
between kobject and sysfs is ugly at a lot of places.

>>> On the other side I can't pass a tag through from the device layer to
>>> the kobject layer.  It isn't a concept the kobject layer supports.
>> I think it's best to make kobject layer support it.
> 
> Assuming Greg will accept it when he sees reasonable patches.

Greg says he would.  :-)

Thanks a lot for your patience.

-- 
tejun
