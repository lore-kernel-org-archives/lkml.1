Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484Ab0ASRii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab0ASRii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 12:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750703Ab0ASRih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 12:38:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab0ASRig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 12:38:36 -0500
Date: Tue, 19 Jan 2010 18:37:43 +0100 (CET)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Steven Rostedt <srostedt@redhat.com>
cc: Mike Frysinger <vapier@gentoo.org>,
       =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kconfig: dont hardcode path to lsmod
In-Reply-To: <1263919075.2737.134.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1001191833040.5999@localhost.localdomain>
References: <1263883920-17289-1-git-send-email-vapier@gentoo.org>  <20100119142545.GB3473@hack>  <520f0cf11001190822t6d3221bco20739d586608bfde@mail.gmail.com>  <alpine.LFD.2.00.1001191723030.5999@localhost.localdomain>
 <1263919075.2737.134.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Jan 2010, Steven Rostedt wrote:

> On Tue, 2010-01-19 at 17:29 +0100, John Kacur wrote:
> 
> > diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
> > index 0d80082..1803d2e 100644
> > --- a/scripts/kconfig/streamline_config.pl
> > +++ b/scripts/kconfig/streamline_config.pl
> > @@ -238,7 +238,8 @@ foreach my $makefile (@makefiles) {
> >  my %modules;
> >  
> >  # see what modules are loaded on this system
> > -open(LIN,"/sbin/lsmod|") || die "Cant lsmod";
> > +# If lsmod isn't in the sbin dir, check if it is in the path
> > +open(LIN,"/sbin/lsmod|") || open(LIN,"lsmod|") || die "Cant lsmod";
> 
> I've tried this before, but it gives an error that the "|" pipe failed.
> 
> -- Steve
> 
> 
> >  while (<LIN>) {
> >  	next if (/^Module/);  # Skip the first line.
> >  	if (/^(\S+)/) {
> 
> 

Are you sure? It works for my test toy program.
First tested with the hardcoded path, and then giving a nonsense name 
instead of sbin so that it uses the PATH variable.

John
