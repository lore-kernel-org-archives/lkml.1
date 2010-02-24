Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395Ab0BXXNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 18:13:53 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:45073 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334Ab0BXXNw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 18:13:52 -0500
X-Greylist: delayed 1581 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2010 18:13:52 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [linuxtools-dev] Standard protocols/interfaces/formats forperformance tools (TCF, LTTng, ...)
Date: Wed, 24 Feb 2010 14:47:23 -0800
Message-ID: <D86DB60C62D82A4792CAEC7F58CA04E706C13E65@NA1-MAIL.mgc.mentorg.com>
In-Reply-To: <20100224154021.GA9692@Krystal>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [linuxtools-dev] Standard protocols/interfaces/formats forperformance tools (TCF, LTTng, ...)
Thread-Index: Acq1Z7lyhFkszr9gRHerMevRWJOTagAM+6HA
References: <D86DB60C62D82A4792CAEC7F58CA04E706C13BB6@NA1-MAIL.mgc.mentorg.com> <20100224154021.GA9692@Krystal>
From: "Spear, Aaron" <aaron_spear@mentor.com>
To: "Linux Tools developer discussions" <linuxtools-dev@eclipse.org>
Cc: <dsdp-tcf-dev@eclipse.org>, <ltt-dev@lists.casi.polymtl.ca>,
       <linux-kernel@vger.kernel.org>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Tasneem Brutch - SISA" <t.brutch@sisa.samsung.com>
X-OriginalArrivalTime: 24 Feb 2010 22:47:28.0074 (UTC) FILETIME=[57330AA0:01CAB5A3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu, 

More dialogue below: 

> -----Original Message-----
> From: linuxtools-dev-bounces@eclipse.org 
> [mailto:linuxtools-dev-bounces@eclipse.org] On Behalf Of 
> Mathieu Desnoyers
> Sent: Wednesday, February 24, 2010 8:40 AM
> To: Linux Tools developer discussions
> Cc: dsdp-tcf-dev@eclipse.org; ltt-dev@lists.casi.polymtl.ca; 
> linux-kernel@vger.kernel.org; Steven Rostedt
> Subject: Re: [linuxtools-dev] Standard 
> protocols/interfaces/formats forperformance tools (TCF, LTTng, ...)
> 
> * Spear, Aaron (aaron_spear@mentor.com) wrote:
> > Hello everyone,
> > 
> > As some of you know, at Mentor Graphics we are currently working on 
> > multi-core profiling products for embedded systems.  The focus 
> > currently is using real-time trace data as the event source for 
> > analysis.  In the future this will expand as we desire to 
> be able to 
> > correlate analysis of heterogeneous systems, e.g. embedded Linux + 
> > LTTng events on one machine, correlated with real-time trace data 
> > collected from a bunch of DSP's.
> > 
> > Like the rest of you, we have spent much time in the past inventing 
> > proprietary data collection frameworks, mechanisms and 
> formats only to 
> > eventually throw them away because a standard eventually 
> emerges.  We 
> > would like to stop the insanity.
> > 
> > So, as an FYI, I am planning to participate in a new tools 
> > infrastructure working group under the auspices of the Multi-core 
> > association (http://www.multicore-association.org).  The 
> working group 
> > aims to:
> > 
> > 1.  Identify common needs, functionality, and opportunities for 
> > information sharing between performance analysis tools.
> > 2.  Discussion on identifying sharable components between 
> performance 
> > analysis tools.
> > 3.  Discussion on metadata dimensions of interest for 
> standardization 
> > (e.g., code, space, metric, time, state)
> > 
> > Along those lines, we (Mentor) have a need for a protocol 
> to connect 
> > to remote trace collectors and configure trace 
> triggering/collection, 
> > and then efficiently download lots of binary trace data.  
> Sound familiar?
> > 
> > TCF is an obvious choice for this as various companies are already 
> > using it for this purpose from what I have observed.
> > 
> > So, to my point:
> > -What protocols are currently in use that we might consider as a 
> > starting point?  I see that the linuxtools project 
> apparently has one 
> > for transferring LTTng event data.  Are there any docs for this 
> > protocol?
> > 
> > -Is there any other company with a proprietary protocol that would 
> > consider donating it to a standardization effort? (some one 
> else who 
> > also desires to end the insanity :-)
> > 
> > -file formats: event log file formats is another obvious 
> candidate for 
> > standardization.  Mentor has a file format we use that was 
> inspired by 
> > LTTng's format but is optimized for extremely large real-time trace 
> > logs.  I intend to throw this into the mix.  Any others we should 
> > think about? (The LTTng format obviously...)
> 
> Hi Aaron,
> 
> I would be glad to provide insight into the LTTng file format 
> as needed.

Great! Insight and experience gleaned from your work is certainly
desired.

> 
> It would be good to ask if the Ftrace team is interested to 
> participate in this standardization effort. Proposing 
> modifications to the Ftrace file format is on my roadmap.

I must confess that I know nothing about Ftrace.  That said, any prior
art in the space of file formats and protocols for exchanging profiling
and trace data should be considered, and input from existing communities
is warmly welcomed.  The charter of this multi-core working group is to
help forge some interoperability standards between different tools as a
start.  We believe that the future will be heavily multi-core, and it is
a difficult problem to solve figuring out graceful ways to partition a
complex "application" across these cores effectively.  E.g. a system
with SMP Linux on a couple of cores, a low level RTOS on another core,
and then some DSP's as well.  Today you often use totally different
tools for all of those cores.  How do you understand what the heck is
happening in this system, never mind figuring out how to optimize the
system as a whole...   I think a good first step is some level of
interoperability in data formats so that event data collected from
different sources and technologies (e.g. LTTng for Linux and real-time
trace for the DSP's) can be correlated and analyzed side by side. 

Note btw that this is just me being proactive and taking some liberty at
this point to get discussion started.  I don't (yet) have any official
sanction from the MC working group, though I know these thoughts
resonate with various initial participants (some of whom I know are on
these lists)
 
> I'm curious.. which version of the LTTng trace file format 
> have you derived your own format from ?

I just tried to look and cannot remember the exact version of LTTng that
I initially played with and studied now.  Not sure if it tells you, but
lttctl says it is version 0.70-18082009 on a 2.6.30 kernel.  I patched
and rebuilt the kernel on top of an Ubuntu 9.04 about 8 months ago or
so.  I will be working on polishing my spec a bit and will circulate for
people to look at as soon as I can.  I have a non-related deadline I am
fighting right now, so it may be a couple of weeks.

Best regards,
Aaron

> 
> Thanks,
> 
> Mathieu
> 
> > 
> > Best regards,
> > Aaron
> > 
> > --
> > Aaron Spear      
> > Debug Tools Architect/Staff Engineer
> > Embedded Systems Division
> > Mentor Graphics Corporation
> > Office: 303-679-8457
> > 
> > 
> > _______________________________________________
> > linuxtools-dev mailing list
> > linuxtools-dev@eclipse.org
> > https://dev.eclipse.org/mailman/listinfo/linuxtools-dev
> > 
> 
> --
> Mathieu Desnoyers
> Operating System Efficiency Consultant
> EfficiOS Inc.
> http://www.efficios.com
> _______________________________________________
> linuxtools-dev mailing list
> linuxtools-dev@eclipse.org
> https://dev.eclipse.org/mailman/listinfo/linuxtools-dev
> 
