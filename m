Return-Path: <linux-kernel-owner+w=401wt.eu-S1759309AbYBSS6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309AbYBSS6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbYBSS6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:58:22 -0500
Received: from bipbip.grupopie.com ([195.23.16.24]:53980 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbYBSS6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:58:21 -0500
Message-ID: <47BB26CB.8010705@grupopie.com>
Date: Tue, 19 Feb 2008 18:58:19 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.14 (X11/20071210)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: very poor ext3 write performance on big filesystems?
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de> <20080218141640.GC12568@mit.edu> <47BB2008.6070202@rtr.ca>
In-Reply-To: <47BB2008.6070202@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Theodore Tso wrote:
> ..
>> The following ld_preload can help in some cases.  Mutt has this hack
>> encoded in for maildir directories, which helps.
> ..
> 
> Oddly enough, that same spd_readdir() preload craps out here too
> when used with "rm -r" on largish directories.

 From looking at the code, I think I've found at least one bug in opendir:
...
> 			dnew = realloc(dirstruct->dp, 
> 				       dirstruct->max * sizeof(struct dir_s));
...

Shouldn't this be: "...*sizeof(struct dirent_s));"?

-- 
Paulo Marques - www.grupopie.com

"Nostalgia isn't what it used to be."
