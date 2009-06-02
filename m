Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbZFBULh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbZFBULh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbZFBUL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:11:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58781 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbZFBULZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:11:25 -0400
Message-ID: <4A25876A.1010901@garzik.org>
Date: Tue, 02 Jun 2009 16:11:22 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ANNOUNCE: mdadm 3.0 - A tool for managing Soft RAID under Linux
References: <18980.48553.328662.80987@notabene.brown>
In-Reply-To: <18980.48553.328662.80987@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> 
> I am pleased to (finally) announce the availability of
>    mdadm version 3.0
> 
> It is available at the usual places:
>    countrycode=xx.
>    http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
> and via git at
>    git://neil.brown.name/mdadm
>    http://neil.brown.name/git?p=mdadm
> 
> 
> This is a major new version and as such should be treated with some
> caution.  However it has seen substantial testing and is considerred
> to be ready for wide use.
> 
> 
> The significant change which justifies the new major version number is
> that mdadm can now handle metadata updates entirely in userspace.
> This allows mdadm to support metadata formats that the kernel knows
> nothing about.
> 
> Currently two such metadata formats are supported:
>   - DDF  - The SNIA standard format
>   - Intel Matrix - The metadata used by recent Intel ICH controlers.

This seems pretty awful from a support standpoint:  dmraid has been the 
sole provider of support for vendor-proprietary up until this point.

Now Linux users -- and distro installers -- must choose between software 
RAID stack "MD" and software RAID stack "DM".  That choice is made _not_ 
based on features, but on knowing the underlying RAID metadata format 
that is required, and what features you need out of it.

dmraid already supports
	- Intel RAID format, touched by Intel as recently as 2007
	- DDF, the SNIA standard format

This obviously generates some relevant questions...

1) Why?  This obviously duplicates existing effort and code.  The only 
compelling reason I see is RAID5 support, which DM lacks IIRC -- but the 
huge issue of user support and duplicated code remains.

2) Adding container-like handling obviously moves MD in the direction of 
DM.  Does that imply someone will be looking at integrating the two 
codebases, or will this begin to implement features also found in DM's 
codebase?

3) What is the status of distro integration efforts?  I wager the distro 
installer guys will grumble at having to choose among duplicated RAID 
code and formats.

4) What is the plan for handling existing Intel RAID users (e.g. dmraid 
+ Intel RAID)?  Has Intel been contacted about dmraid issues?  What does 
Intel think about this lovely user confusion shoved into their laps?

5) Have the dmraid maintainer and DM folks been queried, given that you 
are duplicating their functionality via Intel and DDF RAID formats? 
What was their response, what issues were raised and resolved?

	Jeff



