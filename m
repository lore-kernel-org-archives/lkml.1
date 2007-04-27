Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbXD0HT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbXD0HT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbXD0HT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:19:26 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:33641 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437AbXD0HTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:19:25 -0400
Date: Fri, 27 Apr 2007 09:01:44 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: ebiederm@xmission.com, akpm@linux-foundation.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, hpa@zytor.com
Subject: Re: [patch] unprivileged mounts update
In-Reply-To: <E1HhAYu-000361-00@dorka.pomaz.szeredi.hu>
Message-ID: <Pine.LNX.4.61.0704270859520.506@yvahk01.tjqt.qr>
References: <E1HgcBv-00049Z-00@dorka.pomaz.szeredi.hu>
 <E1HgjG0-0005CN-00@dorka.pomaz.szeredi.hu> <m1r6q8s735.fsf@ebiederm.dsl.xmission.com>
 <Pine.LNX.4.61.0704262107130.506@yvahk01.tjqt.qr> <E1HhAYu-000361-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 26 2007 22:27, Miklos Szeredi wrote:
>> On Apr 25 2007 11:21, Eric W. Biederman wrote:
>> >>
>> >> Why did we want to use fsuid, exactly?
>> >
>> >- Because ruid is completely the wrong thing we want mounts owned
>> >  by whomever's permissions we are using to perform the mount.
>> 
>> Think nfs. I access some nfs file as an unprivileged user. knfsd, by
>> nature, would run as euid=0, uid=0, but it needs fsuid=jengelh for
>> most permission logic to work as expected.
>
>I don't think knfsd will ever want to call mount(2).

I was actually out at something different...

        /* Make sure a caller can chown. */
        if ((ia_valid & ATTR_UID) &&
            (current->fsuid != inode->i_uid ||
             attr->ia_uid != inode->i_uid) && !capable(CAP_CHOWN))
                goto error;

for example. Using current->[e]uid would not make sense here.

>But yeah, I've been convinced, that using fsuid is the right thing to
>do.

Jan
-- 
