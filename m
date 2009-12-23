Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbZLWV7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbZLWV7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757203AbZLWV7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:59:05 -0500
Received: from mail.perches.com ([173.55.12.10]:1390 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177AbZLWV7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:59:04 -0500
Subject: Re: get_maintainers.pl & acer-wmi
From: Joe Perches <joe@perches.com>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: linville@tuxdriver.com, linux-kernel@vger.kernel.org, len.brown@intel.com
In-Reply-To: <200912232135.33356.carlos@strangeworlds.co.uk>
References: <200912232135.33356.carlos@strangeworlds.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Dec 2009 13:59:02 -0800
Message-ID: <1261605542.1923.37.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-23 at 21:35 +0000, Carlos Corbacho wrote:
> Hi Joe,

Hi Carlos.

> We're getting some odd results out of get_maintainers.pl for acer-wmi.
> 
> ccorbacho@pacifica:~/src/kernel/linux-2.6$ perl scripts/get_maintainer.pl -f 
> drivers/platform/x86/acer-wmi.c
> 
> Carlos Corbacho <carlos@strangeworlds.co.uk>
> John W. Linville <linville@tuxdriver.com>
> Len Brown <len.brown@intel.com>
> Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Johannes Berg <johannes@sipsolutions.net>
> linux-kernel@vger.kernel.org
> 
> Which is odd, as I'm the only maintainer of acer-wmi, so why does it pull in 
> all the other names above?

You have git installed.

get_maintainer.pl by default uses git commit history and searches
for signatures.

These are people that have added "acked-by", "signed-off-by",
"reviewed-by" or any other "by" lines in the git commits.

$ ./scripts/get_maintainer.pl -f drivers/platform/x86/acer-wmi.c
Carlos Corbacho <carlos@strangeworlds.co.uk>
John W. Linville <linville@tuxdriver.com>
Len Brown <len.brown@intel.com>
Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Johannes Berg <johannes@sipsolutions.net>
linux-kernel@vger.kernel.org

If you want to not use git history, add --nogit

$ ./scripts/get_maintainer.pl -f --nogit drivers/platform/x86/acer-wmi.c
Carlos Corbacho <carlos@strangeworlds.co.uk>
linux-kernel@vger.kernel.org

With the latest version of get_maintainer, you could add
--rolestats and see how many of the commits were signed
by each person.

$ ./scripts/get_maintainer.pl -f --rolestats drivers/platform/x86/acer-wmi.c
Carlos Corbacho <carlos@strangeworlds.co.uk> (maintainer:ACER WMI LAPTOP E...,commit_signer:4/11=36%)
John W. Linville <linville@tuxdriver.com> (commit_signer:5/11=45%)
Len Brown <len.brown@intel.com> (commit_signer:4/11=36%)
Alan Jenkins <alan-jenkins@tuffmail.co.uk> (commit_signer:3/11=27%)
Johannes Berg <johannes@sipsolutions.net> (commit_signer:2/11=18%)
linux-kernel@vger.kernel.org (open list)



