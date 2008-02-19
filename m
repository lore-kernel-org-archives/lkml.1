Return-Path: <linux-kernel-owner+w=401wt.eu-S1763337AbYBSWeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763337AbYBSWeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757126AbYBSWdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:33:53 -0500
Received: from rtr.ca ([76.10.145.34]:1032 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919AbYBSWdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:33:52 -0500
Message-ID: <47BB594E.1050103@rtr.ca>
Date: Tue, 19 Feb 2008 17:33:50 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Paulo Marques <pmarques@grupopie.com>
Cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: very poor ext3 write performance on big filesystems?
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de> <20080218141640.GC12568@mit.edu> <47BB2008.6070202@rtr.ca> <47BB26CB.8010705@grupopie.com>
In-Reply-To: <47BB26CB.8010705@grupopie.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paulo Marques wrote:
> Mark Lord wrote:
>> Theodore Tso wrote:
>> ..
>>> The following ld_preload can help in some cases.  Mutt has this hack
>>> encoded in for maildir directories, which helps.
>> ..
>>
>> Oddly enough, that same spd_readdir() preload craps out here too
>> when used with "rm -r" on largish directories.
> 
>  From looking at the code, I think I've found at least one bug in opendir:
> ...
>>             dnew = realloc(dirstruct->dp,                        
>> dirstruct->max * sizeof(struct dir_s));
> ...
> 
> Shouldn't this be: "...*sizeof(struct dirent_s));"?
..

Yeah, that's one bug.
Another is that ->fd is frequently left uninitialized, yet later used.

Fixing those didn't change the null pointer deaths, though.


