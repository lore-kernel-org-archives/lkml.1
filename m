Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbYGURoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbYGURoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 13:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbYGURn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 13:43:56 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:14141 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbYGURnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 13:43:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cA6UB4HdAqZyqDYukeNYrJSNAw2zTZiMvvFyvqnCX9/Wyybpm3EX6gk0xf7u0IuOei
         ywCYHyJmTWzeX/x+56wacCeIo/lRulS3qJdfforg3xqPcRo+QqZ5fM4zc4AiBZtD7aiK
         SZU7LWmWylcZIObMnqoR14E2Hj7suQB1KdWHQ=
Message-ID: <4884CAD3.3080101@gmail.com>
Date: Mon, 21 Jul 2008 14:43:47 -0300
From: "Rafael C. de Almeida" <almeidaraf@gmail.com>
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
Subject: Re: request for comment: generic kernel interface for malware vendors
References: <1216613887.2960.18.camel@localhost.localdomain>
In-Reply-To: <1216613887.2960.18.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> First I'd like to thank Sophos who stepped up and originally wrote a lot
> of this code.  They might not recognize it since I've gotten my hands on
> it, but they were nice enough to get the ball rolling by giving me some
> GPL code which addressed near every request people on the malware list
> had.
> 
> At the moment all of the code (over)uses the name talpa.  I expect this
> group of people to come up with a new name for this interface, but since
> that's how the patches started and I couldn't come up with anything I
> love the patches still say talpa.  So if nothing else, lets come up with
> suggestions.  For a little bit I plan to carry these as purely out of
> tree patches but can move development somewhere like a git tree as they
> settle down.  Feel free to send me comments/patches in an manner you see
> fit.  I'm here to help.
> 
> This is a request for comment.  This is a first stab and I'm here to
> address all of the concerns that people have.  Please don't hold back,
> I've got thick skin.  BUT, I don't want to hear 'this is how we have
> been doing it, do it that way.'  I want to hear how this won't work for
> your needs (and WHY) or how we can do it better.
> 
> you can find the patches at:
> http://people.redhat.com/~eparis/talpa
> 
> (1, 3, and 9 are by FAR the most interesting)
> 
> FOR NOW it comes with no documentation.  This is just a code dump since
> I'm just in a rush.  I fly out for OLS in 5 hours.  Speaking of OLS, I'm
> going to be there.  If you are going to be there and want to talk about
> these patches, other patches, your needs, or really anything let me
> know.
> 
> So what's at that web site?  There are 10 patches against Linus's git
> tree.
> 
> 1 - ****hooks, basics, infrastructure
> 2 - configuration generic stuff for the other patches
> 3 - ****results caching
> 4 - exclusions based on the operation or filetype
> 5 - per process exclusions
> 6 - filesystem type exclusions
> 7 - patch exclusions, don't scan when accessed through certain path
> 8 - patch inclusions, only scanning selected things
> 9 - ****userspace vetting, the big stuff
> 10 - operating when userspace is broken
> 
> patch 8 i'm not a fan of.  I really don't like path name security and
> while path exclusions means we might scan more than we should
> considering how unreliable and useless path names are path inclusions
> means we might miss things.  I always find missing things to be rather
> unacceptable.  Unless someone feels strongly I plan to drop patch 8
> altogether (I also haven't reviewed it at all since I got it from
> Sophos)
> 
> After (or maybe during) this next week I'll try to explain how all of
> this works but for now this is just a code dump.  1, 3 and 9 are by FAR
> the most interesting patches.  Patch 9 includes an example userspace
> client that denies access to the file /root/denyme if it contains
> exactly the string "bad."
> 
> I am trying to get something (that works) out there as soon as I can, so
> please, don't take what you see as set in stone.  Give me comments.
> What should I have done better?  Both in terms of what I'm doing and
> what you need?
> 

I'm a newbie here, so don't take me too serious. But I don't see why
that needs a kernel interface, at least from the example on the
Documentation directory (patch 9). Seems to me you could just use file
permission to deny or allow the access for a certain file. The only
thing that would be a little trickier from user-space is to know when a
given file is read. So, talpa should do only that or you could take
advantage of preload like trickle does for bandwidth shapping.
