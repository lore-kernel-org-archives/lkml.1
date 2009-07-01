Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbZGAJIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbZGAJIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbZGAJHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:07:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40463 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445AbZGAJHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:07:40 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH 1/2] CPUFREQ: Remove unneeded dbs_mutexes from ondemand and conservative governors
Date: Wed, 1 Jul 2009 11:07:38 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.23-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, stable@kernel.org,
       hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org, rjw@sisk.pl, penberg@cs.helsinki.fi,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, davej@redhat.com,
       mingo@elte.hu, kernel-testers@vger.kernel.org
References: <20090623193215.GA31374@elte.hu> <20090630231452.GA23217@Krystal> <20090630233912.GA3709@kroah.com>
In-Reply-To: <20090630233912.GA3709@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907011107.40045.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 July 2009 01:39:12 Greg KH wrote:
> On Tue, Jun 30, 2009 at 07:14:52PM -0400, Mathieu Desnoyers wrote:
> > * Greg KH (greg@kroah.com) wrote:
> > > I don't see the patch below in Linus's tree.  If it's there, what is the
> > > git commit id?
> > > 
> > 
> > As I pointed out in an earlier reply, this patch is bogus and adds racy
> > data structure updates. It should not be merged.
> 
> Ok, dropped.

Yes, sorry for not mentioning.

I looked at it again, but gave up after a while, I am not able
to provide a safe .30 fix for that, risk of making things worse
is too high...
My last thought was that the main culprit is that .governor() should
always be called with the rwsem held. I look at it further and try
to ease up things for future kernels, but can't spent that much
time on it currently.

   Thomas
