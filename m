Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbXFIPrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbXFIPrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 11:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbXFIPra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 11:47:30 -0400
Received: from tresys.irides.com ([216.250.243.126]:36023 "HELO
	exchange.columbia.tresys.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753873AbXFIPr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 11:47:29 -0400
X-Greylist: delayed 847 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Jun 2007 11:47:29 EDT
Message-ID: <466AC833.5070306@manicmethod.com>
Date: Sat, 09 Jun 2007 11:33:07 -0400
From: Joshua Brindle <method@manicmethod.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: david@lang.hm
CC: Sean <seanlkml@sympatico.ca>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
References: <20070514110607.549397248@suse.de> <200706042303.28785.agruen@suse.de> <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <Pine.LNX.4.64.0706082207260.6675@asgard.lang.hm> <20070609014644.9ed4fa29.seanlkml@sympatico.ca> <Pine.LNX.4.64.0706090004290.6675@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706090004290.6675@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jun 2007 15:33:21.0574 (UTC) FILETIME=[82E84C60:01C7AAAB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Sat, 9 Jun 2007, Sean wrote:
> <snip>
>
> what SELinux cannot do is figure out what label to assign a new file.
>

Nit: SELinux figures out what to label new files fine, just not based on 
the name. This works in most cases, eg., when user_t creates a file in 
/tmp it becomes user_tmp_t, incidentally this is something that AA 
cannot handle, if the filenames aren't normalized (they normally 
aren't). For example, my ssh agent socket is stored in 
/tmp/ssh-XXXXXXXX, where the X's are random characters, AA can't 
differentiate admin ssh agents from unprivileged user ssh agents, 
showing a serious flaw in their model.

The complaint is that name-based labeling doesn't currently exist (and 
as Sean has stated that doesn't mean it _can't_ exist, just that it 
doesn't currently). In practice this has not been as big of an issue as 
you are making it out to be. Granted restorecond has a tiny race, and I 
wouldn't recommend using it on very security sensitive files but for 
usability having it relabel user_home_t to user_http_content_t isn't a 
problem (and causes no security issues).

