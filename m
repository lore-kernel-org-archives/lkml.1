Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYH2Jg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYH2Jg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 05:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYH2Jgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 05:36:46 -0400
Received: from relay2.mail.vrmd.de ([81.28.224.28]:35789 "EHLO
	relay2.mail.vrmd.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbYH2Jgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 05:36:45 -0400
X-Greylist: delayed 1360 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2008 05:36:45 EDT
Date: Fri, 29 Aug 2008 09:13:46 +0000
From: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, alan-jenkins@tuffmail.co.uk,
       kovlensky@interia.pl
Subject: Re: mounting windows shares with path exactly like on windows
Message-ID: <20080829091346.GA744@ds20.borg.net>
Reply-To: dl8bcu@dl8bcu.de
Mail-Followup-To: dl8bcu@dl8bcu.de, Tomasz Chmielewski <mangoo@wpkg.org>,
	LKML <linux-kernel@vger.kernel.org>, alan-jenkins@tuffmail.co.uk,
	kovlensky@interia.pl
References: <48B7B86B.8090104@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B7B86B.8090104@wpkg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Relay-User: dl8bcu@dl8bcu.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 10:50:51AM +0200, Tomasz Chmielewski wrote:
> Alan Jenkins wrote:
>
>> Tomasz Chmielewski wrote:
>>>> In short - I've got bunch of applications running both on windows and
>>>> linux and these applications \
>>>> exchange links to files mounted on both sides. The problem is that
>>>> these paths are different, i.e. like \
>>>> D:/dir/file on windows and /mountpoint/dir/file on Linux. What I need
>>>> is unifying them. So my idea is to \
>>>> have path translator on anything on kernel level, which will make
>>>> Linux open call to D:/dir/file on Linux \
>>>> work and open /mountpoint/dir/file. Was anything close to that ever
>>>> incorporated in kernel?
>>>
>>> What's wrong with just:
>>>
>>> # mkdir -p /D:/dir
>>> # mount.cifs ...
>>> # touch /D:/dir/file
>>>
>>> ?
>>>
>>> Or, use symlinks from /D:/dir to /mountpoint/dir/
>> That only works from the root directory though.  In unix, "C:/" is a
>> relative path.
>
> Yeah, creating "C:" symlink in each and every directory accessed by the 
> application doesn't sound like a neat solution.

current working directory, actually. Which means you don't necessarily have
to use the filesystem root but only a proper start directory for these
mounts/links. But yeah, we don't know if said proprietary application 
does/doesn't cwd() to it. 

I suggest extending this mess a bit:

# mkdir -p /server/share
# mount.cifs ... 

and use UNC paths. '//server/share/dir/file.txt' will work out nicely :-)

Thorsten.

> BTW, it's the first time I hear about a unix application which has paths 
> like D:/ or C:/ hardcoded.
>
>
> -- 
> Tomasz Chmielewski
> http://wpkg.org

-- 
| Thorsten Kranzkowski        Internet: dl8bcu@dl8bcu.de                      |
| Mobile: ++49 170 1876134       Snail: Kiebitzstr. 14, 49324 Melle, Germany  |
| Ampr: dl8bcu@db0lj.#rpl.deu.eu, dl8bcu@marvin.dl8bcu.ampr.org [44.130.8.19] |
