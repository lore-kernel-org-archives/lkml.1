Return-Path: <linux-kernel-owner+w=401wt.eu-S1752383AbXE2XZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbXE2XZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 19:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbXE2XZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 19:25:44 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:53792
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbXE2XZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 19:25:43 -0400
Date: Tue, 29 May 2007 16:25:54 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@ucw.cz>
cc: Crispin Cowan <crispin@novell.com>, Cliffe <cliffe@iinet.net.au>,
       casey@schaufler-ca.com, Kyle Moffett <mrmacman_g4@mac.com>,
       linux-security-module <linux-security-module@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM
 hook
In-Reply-To: <20070529144518.GD5840@ucw.cz>
Message-ID: <Pine.LNX.4.64.0705291622430.31474@asgard.lang.hm>
References: <653438.15244.qm@web36612.mail.mud.yahoo.com> <465AE46B.4090109@iinet.net.au>
 <465B57D7.2040101@novell.com> <20070529144518.GD5840@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007, Pavel Machek wrote:

> Hi!
>
>>> If we want "/etc/shadow" to be the only way to access the shadow file
>>> we could label the data with "/etc/shadow". Any attempts to access
>>> this data using a renamed file or link would be denied (attempts to
>>> link or rename could also be denied).
>> Eloquently put.
>>
>> AppArmor actually does something similar to this, by mediating all of
>> the ways that you can make an alias to a file. These are:
> ...
>>     * Hard links: AppArmor explicitly mediates permission to make a hard
>
> Unfortunately, aparmor is by design limited to subset of distro
> (network daemons). Unfortunately, some other programs (passwd, vi)
> routinely make hardlinks. So AA mediating hardlink is not enough, as
> vi will happily hardlink /etc/shadow into /etc/.vi-shadow-1234.

but with the AA design of default deny this isn't a big problem unless you 
specificly allow some network daemon to access /etc/.vi-shadow-1234

in this context passwd and vi are considered trusted processes, they are 
used _after_ you authenticate onto the box.

no, this won't help you much against local users, but there are a _lot_ of 
boxes out there with few, if any, local users who don't also have the root 
password. AA helps the admin be safer when configuring netwrok daemons.

David Lang
