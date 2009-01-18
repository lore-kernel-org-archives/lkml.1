Return-Path: <linux-kernel-owner+w=401wt.eu-S934702AbZARSEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934702AbZARSEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 13:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbZARSEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 13:04:36 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41768 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752395AbZARSEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 13:04:36 -0500
Subject: Re: x86/Voyager
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Brian Gerst <brgerst@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <73c1f2160901180941o5ffceaeq3455483cd40fa45f@mail.gmail.com>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
	 <1232115396-26367-3-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-4-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-5-git-send-email-brgerst@gmail.com>
	 <4972B8AB.8040001@kernel.org>
	 <73c1f2160901172157j6cd731e5s187e98a069a3ab96@mail.gmail.com>
	 <4972C53C.5050509@kernel.org>
	 <73c1f2160901172251t34e824ecue6323ce04fc494e9@mail.gmail.com>
	 <20090118071427.GA29613@elte.hu>
	 <1232296885.3247.17.camel@localhost.localdomain>
	 <73c1f2160901180941o5ffceaeq3455483cd40fa45f@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 18 Jan 2009 12:04:32 -0600
Message-Id: <1232301872.3247.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-18 at 12:41 -0500, Brian Gerst wrote:
> On Sun, Jan 18, 2009 at 11:41 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Sun, 2009-01-18 at 08:14 +0100, Ingo Molnar wrote:
> >> If there's no time/interest in that then we can temporarily mark Voyager
> >> CONFIG_BROKEN until cleanup/fix patches arrive.
> >
> > It's not broken and I've already sent you the cleanup/fix patches ... I
> > can send them directly to Linus as voyager maintainer if you prefer.
> 
> The build breakage was due to the cpumask changes I believe, inherited
> from -tip.
> 
> There is alot of duplicated code in voyager_smp.c that is making it
> difficult for me to work on the per-cpu changes.

Actually, there's very little duplicated code, but what there is we can
unify.  The reason it duplicates the API is because it has to provide a
different implementation for voyager ... it's not a PC x86 architecture.

>   Do you see any
> reason that Voyager can't use the normal x86 setup_per_cpu_areas()
> code?

Er, well, yes.  Current setup_per_cpu_areas is setting up the cpu<->apic
maps.  Voyager has no apics, so it has no use for any of the arrays
being set up in there.

If you're proposing to add arrays that would actually be useful to
voyager, then sure we can use it ... it's just at the moment there's no
need.   What is it you want to add in there?

James


