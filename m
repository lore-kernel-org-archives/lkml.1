Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbXFPIJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbXFPIJx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 04:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbXFPIJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 04:09:43 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:46770
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbXFPIJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 04:09:41 -0400
Date: Sat, 16 Jun 2007 01:09:06 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Greg KH <greg@kroah.com>
cc: Crispin Cowan <crispin@novell.com>, Pavel Machek <pavel@ucw.cz>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <20070616003132.GB30127@kroah.com>
Message-ID: <Pine.LNX.4.64.0706160101470.7557@asgard.lang.hm>
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de>
 <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com>
 <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz>
 <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com>
 <20070615234925.GB15056@kroah.com> <Pine.LNX.4.64.0706151656170.12349@asgard.lang.hm>
 <20070616003132.GB30127@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007, Greg KH wrote:

>>> Usually you don't do that by doing a 'mv' otherwise you are almost
>>> guaranteed stale and mixed up content for some period of time, not to
>>> mention the issues surrounding paths that might be messed up.
>>
>>  on the contrary, useing 'mv' is by far the cleanest way to do this.
>>
>>  mv htdocs htdocs.old;mv htdocs.new htdocs
>>
>>  this makes two atomic changes to the filesystem, but can generate thousands
>>  to millions of permission changes as a result.
>
> I agree, and yet, somehow, SELinux today handles this just fine, right?
> :)

no it doesn't, SELinux as-is should take no action when the above command 
is run, but SELinux implementing path-based permissions will have to 
relabel every file or directory in both trees.

> Let's worry about speed issues later on when a working implementation is
> produced, I'm still looking for the logical reason a system like this
> can not work properly based on the expected AA interface to users.

if you are willing to live with the race conditions from the slow 
(re)labeling and write the software to scan the entire system to figure 
out the right policies (and then use inotify to watch the entire system 
for changes and (re)label the appropriate files) and accept that you can't 
get any granular security for filesystems that don't nativly support it 
you could make SELinux behave like AA.

but why should they be required to? are you saying that the LSM hooks are 
not a valid API and should be removed with all future security modules 
being based on SELinux?

David Lang
