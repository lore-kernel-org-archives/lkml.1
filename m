Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbXFVSfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbXFVSfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759444AbXFVSev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:34:51 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:34230
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998AbXFVSeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:34:50 -0400
Date: Fri, 22 Jun 2007 11:35:04 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Stephen Smalley <sds@tycho.nsa.gov>
cc: John Johansen <jjohansen@suse.de>, Lars Marowsky-Bree <lmb@suse.de>,
       James Morris <jmorris@namei.org>, Pavel Machek <pavel@ucw.cz>,
       Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <1182513228.24664.24.camel@moss-spartans.epoch.ncsc.mil>
Message-ID: <Pine.LNX.4.64.0706221118320.14942@asgard.lang.hm>
References: <20070615200623.GA2616@elf.ucw.cz>  <20070615211157.GB7337@kroah.com>
 <46732124.80509@novell.com>  <20070616000251.GG2616@elf.ucw.cz> 
 <20070621160840.GA20105@marowsky-bree.de>  <20070621183311.GC18990@elf.ucw.cz>
  <20070621192407.GF20105@marowsky-bree.de>  <Line.LNX.4.64.0706211530290.483@localhost.localdomain>
  <20070621195400.GK20105@marowsky-bree.de>  <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
  <20070622080640.GB14593@suse.de> <1182513228.24664.24.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Stephen Smalley wrote:

> On Fri, 2007-06-22 at 01:06 -0700, John Johansen wrote:
>> On Thu, Jun 21, 2007 at 04:59:54PM -0400, Stephen Smalley wrote:
>>> On Thu, 2007-06-21 at 21:54 +0200, Lars Marowsky-Bree wrote:
>>>> On 2007-06-21T15:42:28, James Morris <jmorris@namei.org> wrote:
>>>>
>>>
>>>> And now, yes, I know AA doesn't mediate IPC or networking (yet), but
>>>> that's a missing feature, not broken by design.
>>>
>>> The incomplete mediation flows from the design, since the pathname-based
>>> mediation doesn't generalize to cover all objects unlike label- or
>>> attribute-based mediation.  And the "use the natural abstraction for
>>> each object type" approach likewise doesn't yield any general model or
>>> anything that you can analyze systematically for data flow.
>>>
>> No the "incomplete" mediation does not flow from the design.  We have
>> deliberately focused on doing the necessary modifications for pathname
>> based mediation.  The IPC and network mediation are a wip.
>
> The fact that you have to go back to the drawing board for them is that
> you didn't get the abstraction right in the first place.

or it just means that the tool to regulat the network is different from 
the tool to regulate the filesystem.

oh, by the way. that's how the rest of the *nix world works. firewall 
rules apply to networking, filesystem permissions and ACLs apply to the 
filesystem.

this is like climing that the latest improvement to ipsec shouldn't go in 
becouse it down't allow you to handle things the same way that you handle 
temp files or a serial port.

>> We have never claimed to be using pathname-based mediation IPC or networking.
>> The "natural abstraction" approach does generize well enough and will
>> be analyzable.
>
> I think we must have different understandings of the words "generalize"
> and "analyzable".  Look, if I want to be able to state properties about
> data flow in the system for confidentiality or integrity goals (my
> secret data can never leak to unauthorized entities, my critical data
> can never be corrupted/tainted by unauthorized entities - directly or
> indirectly), then I need to be able to have a common reference point for
> my policy.  When my policy is based on different abstractions
> (pathnames, IP addresses, window ids, whatever) for different objects,
> then I can no longer identify how data can flow throughout the system in
> a system-wide way.

if you are doing a system-wide analysis then you are correct.

the AA approach is to start with the exposed items and limit the damage 
that can be done to you.

sysadmins already think in terms of paths and what can access that path 
(directory permissions), AA extends this in a very natural way and doesn't 
require any special tools or extra steps for normal administration. As a 
result sysadmins are far more likely to use this then they are to touch 
anything that requires that they do a full system analysis before they 
start.

another advantage is that since the policies are independant of each other 
it becomes very easy for software to include sample policies with the 
source.

>>> Um, no.  It might not be able to directly open files via that path, but
>>> showing that it can never read or write your mail is a rather different
>>> matter.
>>>
>> Actually it can be analyzed and shown.  It is ugly to do and we
>> currently don't have a tool capable of doing it, but it is possible.
>
> No, it isn't possible when using ambiguous and unstable identifiers for
> the subjects and objects, nor when mediation is incomplete.

it is possible to say that without assistance from an outside process the 
process cannot access the files containing your mail.

if there is some other method of accessing the content no filesystem-level 
thing can know about it (for example, if another process is a pop server 
that requires no password). but I don't beleive that SELinux policies as 
distributed by any vendor would prevent this (yes, it would be possible 
for a tailored policy to prevent it, but if the policy is so complex that 
only distro staff should touch it that doesn't matter in real life)

David Lang
