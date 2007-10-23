Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbXJWMzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbXJWMzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 08:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbXJWMzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 08:55:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54143 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbXJWMzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 08:55:36 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Al Viro <viro@ftp.linux.org.uk>,
       WANG Cong <xiyou.wangcong@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Nix <nix@esperi.org.uk>, Jeff Dike <jdike@addtoit.com>,
       Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
From: Andi Kleen <andi@firstfloor.org>
References: <20071022065202.GI2998@hacking>
	<20071022065943.GC10864@uranus.ravnborg.org>
	<20071022074823.GJ2998@hacking>
	<20071022113600.GA8181@ftp.linux.org.uk>
	<20071022122504.GL2998@hacking>
	<20071022124322.GB8181@ftp.linux.org.uk>
	<20071022124551.GA7438@elte.hu> <471D2ECC.6090209@goop.org>
	<20071022231927.GA30814@elte.hu> <471D389E.40609@goop.org>
	<20071023084546.GA17007@elte.hu>
Date: Tue, 23 Oct 2007 14:55:30 +0200
In-Reply-To: <20071023084546.GA17007@elte.hu> (Ingo Molnar's message of "Tue\, 23 Oct 2007 10\:45\:46 +0200")
Message-ID: <p73wste7zy5.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> the 'fastcall removal' changes to paravirt.c were over-eager: they
> removed fastcall annotations from functions that are (or might be)
> implemented in assembly. So if someone changes the compiler model,
> such as -pg which disables regparm, the kernel breaks in nasty ways.

It would be probably better to just not disable -mregparms. I don't
think the compiler forces this. And e.g. on x86-64 regparms & -pg 
work just fine, why should it not on i386?

> so this patch adds back fastcall annotations. This serves as
> documentation for assembly calling-convention dependencies as
> well.

You should rename it then to "asmcall" or something.

-Andi
