Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbZBFLa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbZBFLa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 06:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbZBFLaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 06:30:13 -0500
Received: from pmx1.sophos.com ([213.31.172.16]:53241 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbZBFLaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 06:30:10 -0500
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Detect mmconfig on nVidia MCP55
Date: Fri, 6 Feb 2009 11:30:05 +0000
User-Agent: KMail/1.9.10
Cc: Ed Swierk <eswierk@aristanetworks.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <1233765552.16414.6.camel@localhost.localdomain> <200902051705.33410.tvrtko.ursulin@sophos.com> <20090205180019.GC9233@elte.hu>
In-Reply-To: <20090205180019.GC9233@elte.hu>
MIME-Version: 1.0
Message-Id: <200902061130.05740.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 06/02/2009 11:30:06,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 06/02/2009 11:30:07,
	Serialize complete at 06/02/2009 11:30:07
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009 18:00:19 Ingo Molnar wrote:
> * Tvrtko Ursulin <tvrtko.ursulin@sophos.com> wrote:
> > On Wednesday 04 February 2009 17:04:40 Ingo Molnar wrote:
> > > 2) Please use vertical spaces when initializing structure fields.
> > > Instead of the messy looking (and over-long-line generating) construct
> > > of:
> > >
> > >         pci_mmcfg_config[0].address = (extcfg & 0x00007fff) << 25;
> > >         pci_mmcfg_config[0].pci_segment = 0;
> > >         pci_mmcfg_config[0].start_bus_number = 0;
> > >         pci_mmcfg_config[0].end_bus_number = (1 << (8 - ((extcfg >> 28)
> > > & 3))) - 1; pci_mmcfg_config_num = 1;
> > >
> > >    You will get something like:
> > >
> > >         config->address                 = (extcfg & 0x00007fff) << 25;
> > >         config->pci_segment             = 0;
> > >         config->start_bus_number        = 0;
> > >         config->end_bus_number          = (1 << (8 - ((extcfg >> 28) &
> > > 3)));
> > >
> > >         pci_mmcfg_config = config;
> > >         pci_mmcfg_config_num = 1;
> > >
> > >    Which makes it more structured, more reviewable - and more pleasant
> > > to look at as well.
>
> It is arch/x86/ and scheduler / etc. policy for new code - and we follow
> that principle when we clean up code as well.

You also didn't say anything about variable declarations I asked about? And I can add structure definition to 
that question as well. 

> Beyond the prettiness and fun to look at factor, there are other advantages
> of vertical spaces as well:
>
> Trivia: you play the role of the code reviewer. I have hidden two typos in
> the initializers above, one in each initializer block. The typos are of the
> same type but are in difference places so both need to be found
> individually.
>
> Try to find the typos, and record the number of seconds it took for you to
> find them. Which typo took less time to find?

Actually test was invalidated by me looking for two typos in each block for a long long time. Therefore by 
providing interesting visual things to look at you made me skip the important bit with instructions. :)

But I personally think it is not such a big difference. And please remember that the part I originally 
commented on was different in a way that it had expressions on the right hand side. There with a huge gap 
between left and right you then break to logical association and make brain evaluate it as two separate groups 
which perhaps doesn't always makes sense.

And how could you say that not vertically aligning increases maximum line length is beyond me.

> I'd suspect that for most people block#1 is the winner.

_You_ think it's fun to look at and you suspect it is the winner, which is basically my point. I think you are 
going to far. Either you specify the rules in CodingStyle or you don't have it as a reason to send patches for 
rework. Until then you can't say it is a policy, it can at least depend on circumstances.

> [ Note, you have a look at it as real source code with fixed width fonts
> and you'll see the difference. You seem to be using KMail or so: there's
> weird line wraps and other corruption of the code in your quote above -
> have you really looked at the real code how it looks like to developers? ]

Yes I have, it looks like ordinary word wrap when replying. I don't see any other corruptions though - have 
you added that just to make it sound more dramatic together with suggesting I am not a developer?

> > I find it a matter of personal preference whether it is more pleasant to
> > look at and whether it is more or less readable.
>
> Is your argument that to you it is less pleasant to look at?

No, my argument is that in this case it is a personal preference what is more pleasant to look at.

> Differences in taste is OK in borderline issues, but i think this one is
> far from being borderline, it's a basic typographic and aesthetic
> principle.

While for some cases I also like vertical alignment, for the original code I think it  was borderline _at 
most_. 

> I'm not sure vertical spaces can be properly described via more rigid
> CodingStyle rules - for example vertical spaces look ugly if there's just
> two field initializations for example - but in the above case they are
> clearly the right thing to do.

Well I don't wish to argue on this subject very much. 

I just thought it is unfair to criticise on an issue which cannot be a hard rule and in a particular example 
was not an improvement. 

Since you also agree it is not possible to describe it as a hard rule, why bother people with it?

Tvrtko
