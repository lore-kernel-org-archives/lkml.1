Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbXFYVEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbXFYVEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbXFYVDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:03:44 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:59864
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbXFYVDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:03:42 -0400
Date: Mon, 25 Jun 2007 14:02:22 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@suse.cz>
cc: Chris Mason <chris.mason@oracle.com>, James Morris <jmorris@namei.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, Lars Marowsky-Bree <lmb@suse.de>,
       Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <20070625151411.GB1018@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0706251358210.20356@asgard.lang.hm>
References: <20070621183311.GC18990@elf.ucw.cz> <20070621192407.GF20105@marowsky-bree.de>
 <Line.LNX.4.64.0706211530290.483@localhost.localdomain>
 <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
 <20070622003436.GB6222@think.oraclecorp.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain>
 <20070622121742.GC6222@think.oraclecorp.com> <Line.LNX.4.64.0706220858170.5751@localhost.localdomain>
 <20070622140240.GM6222@think.oraclecorp.com> <20070625151411.GB1018@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007, Pavel Machek wrote:

> Hi!
>
>> We've been over the "AA is different" discussion in threads about a
>> billion times, and at the last kernel summit.  I think Lars and others
>> have done a pretty good job of describing the problems they are trying
>> to solve, can we please move on to discussing technical issues around
>> that?
>
> Actually, I surprised Lars a lot by telling him ln /etc/shadow /tmp/
> allows any user to make AA ineffective on large part of systems -- in
> internal discussion. (It is not actually a _bug_, but it is certainly
> unexpected).
>
> (Does it surprise you, too? I'm pretty sure it would surprise many users).

no, it doesn't surprise me in the least. AA is controlling access to the 
thing called /etc/shadow, if you grant access to it in other ways you 
bypass the restrictions.

if you follow the ln /etc/shadow /tmp/ with chmod 777 /tmp/shadow the 
system is completely insecure.

this is standard stuff that normal sysadmins expect. it's only people who 
have focused on the label approach who would expect it to be any 
different.

> James summarized it nicely:
>
> # The design of the AppArmor is based on _appearing simple_, but at the
> # expense of completeness and thus correctness.
>
> If even Lars can be surprised by AAs behaviour, I do not think we can
> say "AA is different". I'm afraid that AA is trap for users. It
> appears simple, and mostly does what it is told, but does not do _what
> user wants_.

I thought it had been made very clear that hard links like this were a 
potential way around the restrictions, which is why controlled tasks are 
not allowed to do arbatrary hard links.

David Lang
