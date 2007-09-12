Return-Path: <linux-kernel-owner+w=401wt.eu-S970623AbXILSDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970623AbXILSDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 14:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967318AbXILSDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 14:03:09 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54581 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967204AbXILSDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 14:03:07 -0400
Date: Wed, 12 Sep 2007 20:03:06 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Dan Stromberg <dstromberglists@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Building a kernel-source RPM (not a kernel RPM)?
In-Reply-To: <pan.2007.09.12.17.30.59.597440@gmail.com>
Message-ID: <Pine.LNX.4.64.0709121957400.22467@fbirervta.pbzchgretzou.qr>
References: <pan.2007.09.12.16.13.41.195991@gmail.com>
 <1189616966.31502.75.camel@tara.firmix.at> <pan.2007.09.12.17.30.59.597440@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 12 2007 10:31, Dan Stromberg wrote:
>
>>> I'm on a SuSE system.
>>> 
>>> I'm working on automating the install of said system, but it needs a
>>> Linus kernel - 2.6.21.7 specifically, and it needs kernel source too so
>>> that we can build modules in the field as needed.
>> 
>> Find a kernel-source.*.src.rpm or kernel-*.src.rpm or whatever SuSE 
>> uses for nameing convention and reverse engineer the .spec file. 
>> Fedora BTW abandoned kernel-source* and they have now a website with 
>> a description how to produce a configured kernel source tree (e.g. 
>> for out-of-tree modules).
>
>So this is as smooth as producing kernel-source RPM's gets?
>
>I might be better off sticking with a .tar.bz2 and repointing symlinks.

Do that for a handful of machines and it gets tiresome.

>>> I see you can make an rpm of a bootable kernel with "make rpm".
>> 
>> Well, then there must be a .spec file somewhere which just wants to be
>> extended.
>
>I'm not sure this is going to be any easier to automate, if that's what's
>required.

The 'proper' (though this is not an authoritative answer) way is to 
build the rpm the same way SUSE did. This ensures best compatibility and 
the fewest surprises. I am not saying it is easy, though.

>>> Is there a streamlined way of building a corresponding kernel-source
>>> RPM?  Or do people pretty much all just dump the source in /usr/src, and
>> 
>> Yes, you put all the steps you do by hand into the .spec file. That's
>> it.
>
>I may just stick them in a bash script and forget about the RPM.  Or are
>there other packages that are going to be cranky, dependencywise, if I
>ignore the RPM?

Somewhat. The kernel rpm and 3rd party kernel module rpms share symbols 
so that upgrading will upgrade all the necessary things. (Instead of 
having to go through it all manually.)

>>> manually update symlinks as needed?  If the latter, what symlinks need
>>> to be updated?
>> 
>> Actually nowadays usually there no "sym-link updating" anymore necessary
>
>On OpenSuSE 10.2, there appears to be:

It is not necessary. rpm -Uhv'ing the kernel-source rpm will repoint the 
symlink to the version you just installed.

>> just put the correct ones in /lib/modules/$(uname -r)/ and the full 
>> name in /boot/grub/menu.lst.
>
>Which correct "ones"?  Sometimes pronouns aren't shortcuts :)


Use http://benjiweber.co.uk:8080/webpin/ , and be happy.




	Jan
-- 
