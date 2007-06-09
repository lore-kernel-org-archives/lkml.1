Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbXFIRdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbXFIRdy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 13:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbXFIRdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 13:33:44 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:55184
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140AbXFIRdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 13:33:43 -0400
Date: Sat, 9 Jun 2007 10:32:05 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <DA41D175-3EA3-4ED9-B532-2AA577690980@mac.com>
Message-ID: <Pine.LNX.4.64.0706091028540.6313@asgard.lang.hm>
References: <20070514110607.549397248@suse.de> <200706042303.28785.agruen@suse.de>
 <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de>
 <20070609001703.GA17644@kroah.com> <Pine.LNX.4.64.0706082207260.6675@asgard.lang.hm>
 <23C85F2D-9715-4C9B-BD4D-B7186A71F33D@mac.com> <Pine.LNX.4.64.0706090930380.6313@asgard.lang.hm>
 <DA41D175-3EA3-4ED9-B532-2AA577690980@mac.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007, Kyle Moffett wrote:

> On Jun 09, 2007, at 12:46:40, david@lang.hm wrote:
>> On Sat, 9 Jun 2007, Kyle Moffett wrote:
>> > Typical "targetted" policies leave all user logins as unrestricted, 
>> > adding security for daemons but not getting in the way of users who would 
>> > otherwise turn SELinux off.  On the other hand, a targeted policy has a 
>> > "trusted" type for user logins which is explicitly allowed access to 
>> > everything.
>> 
>> Ok, it sounds as if I did misunderstand SELinux. I thought that by labeling 
>> the individual files you couldn't do the 'only restrict apache' type of 
>> thing.
>> 
>> > That said, if you actually want your system to *work* with any 
>> > default-deny policy then you have to describe EVERYTHING anyways.  How 
>> > exactly do you expect AppArmor to "work" if you don't allow users to run 
>> > "/bin/passwd", for example.
>> 
>> for AA you don't try to define permissions for every executable, and ones 
>> that you don't define policy are unrestricted.
>> 
>> so as I understand this with SELinux you will have lots of labels around 
>> your system (more as you lock down the system more) you need to define 
>> policy so that your unrestricted users must have access to every label, and 
>> every time you create a new label you need to go back to all your policies 
>> to see if the new label needs to be allowed from that policy
>
> Actually, it's easier than that.  There are type attributes which may be 
> assigned to an arbitrary set of types, and each "type" field in an access 
> rule may use either a type or an attribute.  So you don't actually need to 
> modify existing rules when adding new types, you just add the appropriate 
> existing attributes to your new type.  For example, you could set up a 
> "logfile" attribute which allows logrotate to archive old versions and allows 
> audit-admin users to modify/delete them, then whenever you need to add a new 
> logfile you just declare the "my_foo_log_t" type to have the "logfile" 
> attribute.

isn't this just the flip side of the same problem?

every time you define a new attribute you need to go through all the files 
and decide if the new attribute needs to be given to that file.

David Lang

> On the other hand, I seem to recall that typical "targeted" policies don't 
> grant most of the additional access via access rules, they instead add a 
> special case to the fundamental "constraints" in the policy (IE: If the 
> subject type has the "trusted" attribute then skip some of the other 
> type-based checks).
>
> Cheers,
> Kyle Moffett
>
>
