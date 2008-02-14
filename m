Return-Path: <linux-kernel-owner+w=401wt.eu-S1764387AbYBNJq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764387AbYBNJq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 04:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbYBNJqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 04:46:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:48393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbYBNJqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 04:46:14 -0500
To: Jasper Bryant-Greene <jasper@unix.geek.nz>
Cc: rzryyvzy <rzryyvzy@trashmail.net>, linux-kernel@vger.kernel.org
Subject: Re: Is there a "blackhole" /dev/null directory?
From: Andi Kleen <andi@firstfloor.org>
References: <20080214093051.7240852AB0E31@trashmail.net>
	<1202981957.10928.17.camel@phobos.jasper.bg>
Date: Thu, 14 Feb 2008 10:46:11 +0100
In-Reply-To: <1202981957.10928.17.camel@phobos.jasper.bg> (Jasper Bryant-Greene's message of "Thu\, 14 Feb 2008 22\:39\:17 +1300")
Message-ID: <p73pruz27mk.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jasper Bryant-Greene <jasper@unix.geek.nz> writes:
>
> This could be done fairly trivially with FUSE, and IMHO is a good use
> for FUSE because since you're just throwing most data away, performance
> is not a concern.

Q.: how much work would fuse have to do until the user file system
server could decide to ignore the data? 
A.: pretty much all of a cached write including all the copies and
context switches.

That is because FUSE has to first hand all the data to the server
until it can decide to do nothing and that's pretty much all (and then
some more) of the cost of a cached write.

So if you want any performance benefit from this (I'm a little sceptical) you 
should exactly not use FUSE.

The basic problem with the idea is that programs who create temporary
files usually want to read them back at some point too. So if you
throw everything away things break.

If you just don't want the write to not (usually) hit disk you
can use tmpfs, although I believe at least ext2 (not ext3 unfortunately) 
is also reasonably good at not writing out very short lived files.

-Andi
