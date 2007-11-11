Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbXKKBSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbXKKBSc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 20:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbXKKBSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 20:18:23 -0500
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:54699
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXKKBSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 20:18:21 -0500
Date: Sat, 10 Nov 2007 17:27:51 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
In-Reply-To: <20071110235609.00958d87@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0711101720100.4780@asgard.lang.hm>
References: <473380AD.5070801@crispincowan.com> <20071110220455.GB24195@gallifrey>
 <47362C7C.2050202@crispincowan.com> <20071110222414.GC24195@gallifrey>
 <47363381.4030103@crispincowan.com> <20071110232545.GD24195@gallifrey>
 <Pine.LNX.4.64.0711101546400.4780@asgard.lang.hm> <20071110235609.00958d87@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Nov 2007, Alan Cox wrote:

>> but how can the system know if the directory the user wants to add is
>> reasonable or not? what if the user says they want to store their
>> documents in /etc?
>
> A more clear example is wanting to wrap a specific tool with temporary
> rules. Those rules would depend on the exact file being edited at this
> moment - something root cannot know in advance
> (although with apparmor I guess mv $my_file apparmour_magic.name ; foo;
> mv it back might work 8))

the mechanism being desired was that the system administrator would setup 
a restrictive policy and a user who wanted a more permissive policy would 
have the ability to make it more permissive.

this sort of thing is a disaster waiting to happen.

however, if App Armor sets things up so that there can be a system policy 
that users cannot touch, but users can have a secondary policy that layers 
over the system one to restrict things further it could be safe.

if a sysadmin wants to have 'soft' and 'hard' limits of what a user can 
do, they could put the 'hard' limits in the system policy (and the users 
_cannot_ violate these limits), and then set the 'soft' limits in the 
users default setup (similar to how .profile is set by default). if a user 
wants to make things less restrictive they could edit or remove the 
per-user policy, but would still not be able to violate the system policy.

however, while this seems attractive, I'm not sure that madness isn't down 
the road a little bit. since the users policy would only apply to 
themselves, you have the situation that (DAC permissions permitting) the 
files are available to other confined processes becouse they are running 
as other users. this sort of thing will surprise people if the 
explinations aren't done very carefully.

David Lang
