Return-Path: <linux-kernel-owner+w=401wt.eu-S1032552AbXFIBHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032552AbXFIBHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 21:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967307AbXFIBHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 21:07:30 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:57994
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbXFIBH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 21:07:28 -0400
Date: Fri, 8 Jun 2007 18:06:22 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Greg KH <greg@kroah.com>
cc: Andreas Gruenbacher <agruen@suse.de>, Stephen Smalley <sds@tycho.nsa.gov>,
       Pavel Machek <pavel@ucw.cz>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <20070609001703.GA17644@kroah.com>
Message-ID: <Pine.LNX.4.64.0706081757070.18969@asgard.lang.hm>
References: <20070514110607.549397248@suse.de> <200706042303.28785.agruen@suse.de>
 <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de>
 <20070609001703.GA17644@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Greg KH wrote:

> On Sat, Jun 09, 2007 at 12:03:57AM +0200, Andreas Gruenbacher wrote:
>> AppArmor is meant to be relatively easy to understand, manage, and customize,
>> and introducing a labels layer wouldn't help these goals.
>
> Woah, that describes the userspace side of AA just fine, it means
> nothing when it comes to the in-kernel implementation.  There is no
> reason that you can't implement the same functionality using some
> totally different in-kernel solution if possible.
>
>> SELinux is applicable in areas where AppArmor is not (e.g., MLS), but
>> this comes at a cost. For me the question is not SELinux or AppArmor,
>> but if AppArmor's security model is a good solution in common
>> scenarios. In my opinion, AppArmor is a better answer than SELinux in
>> a number of scenarios. This gives it value, nonwithstanding the fact
>> that SELinux can be taken further.
>
> I am still not completely certian that we can not properly implement AA
> functionality using a SELinux backend solution.  Yes, the current tools
> that try to implement this are still lacking, and maybe the kernel needs
> to change, but that is possible.
>
> I still want to see a definition of the AA "model" that we can then use
> to try to implement using whatever solution works best.  As that seems
> to be missing the current argument of if AA can or can not be
> implemented using SELinux or something totally different should be
> stopped.
>
> So, AA developers, do you have such a document anywhere?  I know there
> are some old research papers, do they properly describe the current
> model you are trying to implement here?

Greg,
   to implement the AA approach useing SELinux you need to have a way that 
files that are renamed or created get tagged with the right label 
automaticaly with no possible race condition.

If this can be done then it _may_ be possible to do the job that AA is 
aimed at with SELinux, but the work nessasary to figure out what lables 
are needed on what file would still make it a non-trivial task.

as I understand it SELinux puts one label on each file, so if you have 
three files accessed by two programs such that
program A accesses files X Y
program B accesses files Y Z

then files X Y and Z all need seperate labels with the policy stateing 
that program A need to access labels X, Y and program B needs to access 
files Y Z

extended out this can come close to giving each file it's own label. AA 
essentially does this and calls the label the path and computes it at 
runtime instead of storing it somewhere.

David Lang
