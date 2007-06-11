Return-Path: <linux-kernel-owner+w=401wt.eu-S1764340AbXFKJfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764340AbXFKJfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 05:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbXFKJf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 05:35:28 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:35366
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbXFKJf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 05:35:27 -0400
Date: Mon, 11 Jun 2007 02:33:30 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Sean <seanlkml@sympatico.ca>
cc: Crispin Cowan <crispin@novell.com>, casey@schaufler-ca.com,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <20070611042919.8feffc40.seanlkml@sympatico.ca>
Message-ID: <Pine.LNX.4.64.0706110218070.6675@asgard.lang.hm>
References: <700465.32295.qm@web36612.mail.mud.yahoo.com> <466C6451.6030907@novell.com>
 <Pine.LNX.4.64.0706102328200.6675@asgard.lang.hm> <20070611042919.8feffc40.seanlkml@sympatico.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2007, Sean wrote:

> david@lang.hm wrote:
>
>> say that we give each file a unique label, and for simplicity we set the
>> label == path (note that this raises the issue, what will SELinux do when
>> there are multiple paths to the same file)
>
> So don't do that then.
>
>> now say that you want to grant apache access to all files that have labels
>> that follow the pattern '/home/*/http/* ?
>>
>> you are either going to use regex matching, or you are going to have to
>> enumerate every label that matches this (potentially a very large list).
>> and if you try to generate the enumerated list you need to add a label to
>> the list if a file is renamed or created to match the pattern, and delete
>> a file from the list if it is renamed to no longer match the pattern
>
> If AA requires regex matching in the kernel, perhaps it really isn't
> appropriate for inclusion.  Surely there has to be a better way than
> requiring the kernel to do regex matches at runtime?
>
>> AA over SELinux would need for SELinux to figure out how to handle file
>> creation, file renames, and multiple paths for the same file (hard-links
>> and bind-mounts). In addition a userspace daemon would have to be written
>> to re-label files and/or change policy on the fly as files are renamed.
>> the result would still have race conditions due to the need to re-label
>> large numbers of files
>
> WRONG.  The labels would be obtained from AA as needed, never recorded in
> the file attributes.  This would change nothing about what AA needed
> to compute at runtime, just the way it implements the result.

Ok, you are proposing throwing out all the label handling that SELinux 
does, including any caching. forgive me if I agree with the SELinux people 
that this is a very bad idea.

>> ACPI should have taught everyone that sometimes putting an interpreter in
>> the kernel really is the best option. looking at the problems of bouncing
>> back out to userspace for file creation and renames it looks like a regex
>> in the kernel is a lot safer and more reliable.
>
> There hasn't yet been shown a requirement for a userspace daemon to implement
> AA over SeLinux.

I thought the userspace component was what you were proposing instead of 
doing the regex matching in the kernel. if this isn't it what exactly are 
you proposing?

you don't want the regex matching in the kernel.

you don't want a userspace component to do the regex matching when files 
are created or renamed.

how exactly do you propose to figure out what should happen to a file when 
it is created or it (or a parent directory) is renamed?

AA policies are defined in terms of regex expressions. you say that this 
should be able to be done on top of SELinux somehow without changing the 
policies. so somewhere, something needs to interpret the regex to see if 
it matches the path. this needs to be either kernel code or userspace 
code. you have ruled out kernel code and are now claiming that userspace 
isn't needed.

David Lang
