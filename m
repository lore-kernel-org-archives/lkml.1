Return-Path: <linux-kernel-owner+w=401wt.eu-S1161137AbXDNHPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161137AbXDNHPA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 03:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161139AbXDNHPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 03:15:00 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:33044 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161137AbXDNHO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 03:14:59 -0400
Message-ID: <46207F1D.3010302@gmail.com>
Date: Sat, 14 Apr 2007 09:13:33 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Junio C Hamano <junkio@cox.net>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       git@vger.kernel.org
Subject: Re: GIT and the current -stable
References: <46206842.80203@gmail.com> <7vfy73bhik.fsf@assigned-by-dhcp.cox.net>
In-Reply-To: <7vfy73bhik.fsf@assigned-by-dhcp.cox.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2007 08:24 AM, Junio C Hamano wrote:

> I think adding these lines to .git/config would do the trick,
> after you have done the "checkout -b v2.6.20 v2.6.20" step:
> 
> [branch "v2.6.20"]
> 	remote = stable
> 	merge = refs/heads/master
> [remote "stable"]
> 	url = git://git.kernel.org/.../stable/linux-2.6.20.y.git
> 	fetch = refs/heads/master
> 
> provided if stable team forks v2.6.20.y history off of Linus's
> v2.6.20.
> 
> With the above configuration, anytime you say "git pull" while
> on your v2.6.20 branch will fetch from "stable" and merge their
> 'master' branch in your current branch (i.e. v2.6.20 branch).

Yes, this does seem to work, thanks. Was thrown of a bit by having named the 
branch "v2.6.20". GIT and I disagree what it is that I want to happen when I 
say "git checkout v2.6.20" if v2.6.20 is also a tag on master.

The pull behaviour does not follow further branches:

rene@7ixe4:~/src/linux/local$ git branch
* 2.6.20
   master
rene@7ixe4:~/src/linux/local$ git checkout -b 7ixe4
Switched to a new branch "7ixe4"
rene@7ixe4:~/src/linux/local$ git pull
Warning: No merge candidate found because value of config option
          "branch.7ixe4.merge" does not match any remote branch fetched.
No changes.

This might in practice not be all bad in fact, and I suppose I understand 
how to "fix" it along the same lines as above.

But as happens very frequently with GIT, I get the feeling that I just don't 
understand how it's all intended to be used. It seems that what I wanted 
above is not standard? What would be expected use of the stable GIT repo? 
Just cloning that outright into another repo?

A "GIT WHYTO" from someone with the oversight would be very useful...

Rene.
