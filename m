Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbXFJJGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbXFJJGG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 05:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbXFJJFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 05:05:53 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:34343
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbXFJJFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 05:05:52 -0400
Date: Sun, 10 Jun 2007 02:04:25 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@ucw.cz>
cc: Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <20070610083427.GA24808@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0706100201540.6675@asgard.lang.hm>
References: <20070514110607.549397248@suse.de> <200706042303.28785.agruen@suse.de>
 <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de>
 <20070609001703.GA17644@kroah.com> <Pine.LNX.4.64.0706081757070.18969@asgard.lang.hm>
 <20070610083427.GA24808@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2007, Pavel Machek wrote:

> Hi!
>
>>> So, AA developers, do you have such a document anywhere?  I know there
>>> are some old research papers, do they properly describe the current
>>> model you are trying to implement here?
>>
>> Greg,
>>   to implement the AA approach useing SELinux you need to have a way that
>> files that are renamed or created get tagged with the right label
>> automaticaly with no possible race condition.
>>
>> If this can be done then it _may_ be possible to do the job that AA is
>> aimed at with SELinux, but the work nessasary to figure out what lables
>> are needed on what file would still make it a non-trivial task.
>>
>> as I understand it SELinux puts one label on each file, so if you have
>> three files accessed by two programs such that
>> program A accesses files X Y
>> program B accesses files Y Z
>>
>> then files X Y and Z all need seperate labels with the policy stateing
>> that program A need to access labels X, Y and program B needs to access
>> files Y Z
>>
>> extended out this can come close to giving each file it's own label. AA
>> essentially does this and calls the label the path and computes it at
>> runtime instead of storing it somewhere.
>
> Yes, and in the process, AA stores compiled regular expressions in
> kernel. Ouch. I'll take "each file it's own label" over _that_ any time.

and if each file has it's own label you are going to need regex or similar 
to deal with them as well.

David Lang
