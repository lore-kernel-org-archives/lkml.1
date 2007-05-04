Return-Path: <linux-kernel-owner+w=401wt.eu-S1423097AbXEDTdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423097AbXEDTdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423103AbXEDTdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:33:03 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58034 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423097AbXEDTdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:33:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] Replace paravirt_probe with "platform type" boot header field
References: <1178283582.23670.67.camel@localhost.localdomain>
	<m1zm4ksn5o.fsf@ebiederm.dsl.xmission.com>
	<1178288329.23670.86.camel@localhost.localdomain>
	<m1tzussm4z.fsf@ebiederm.dsl.xmission.com>
	<463B56A0.7090805@zytor.com>
	<m1mz0kr0ux.fsf@ebiederm.dsl.xmission.com>
	<463B69AB.2030706@zytor.com>
	<m1vef8phjy.fsf@ebiederm.dsl.xmission.com>
	<463B81BC.1030504@zytor.com>
	<m1d51gpfqn.fsf@ebiederm.dsl.xmission.com>
	<463B8629.3090309@zytor.com>
Date: Fri, 04 May 2007 13:31:47 -0600
In-Reply-To: <463B8629.3090309@zytor.com> (H. Peter Anvin's message of "Fri,
	04 May 2007 12:14:49 -0700")
Message-ID: <m14pmspeqk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Indeed.  I think, yes, what has been there up to now has pretty much
> been at least in part experimental, and I fear there will be unavoidable
> breakage as part of sanitizing it.  C'est la vie, I guess.

The one significant one I left out I think is the VISWS.  I'm not certain
what we do there, but I know it never went through setup.S

Yes.  At the same time we have been sufficiently disciplined (baring
paravirt) that the changes should be quite small, and we have a big
enough sample size now that we can pretty clearly see ways in which
the code will vary.

>>>> And 4K seems to be our maximum size for backwards compatibility.  Although
>>>> we use it in a fairly sparse way, so we should be ok.
>>> Sort of.  It's pretty full.
>> 
>> True.  For small little extensions we have room.  For big things probably
>> not.
>
> For big extensions we'll probably have to go the pointer route already
> done with the command line.

Likely.  It is tricky because if we actually have to do a normal BIOS
query to get it things a little sticky, because we can't allocate
memory.  Hmm.  It looks like we need a way to export the size of
our parameter area to the bootloader.  We have setup_sects for 16bit
real mode bootloaders and that should be good enough, but we need
something equivalent for the 32bit entry point.

Requirements analysis here we come.

Eric
