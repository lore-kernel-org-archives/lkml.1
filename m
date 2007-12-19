Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbXLSQzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbXLSQzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbXLSQzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:55:38 -0500
Received: from mis011-1.exch011.intermedia.net ([64.78.21.128]:44704 "EHLO
	mis011-1.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754283AbXLSQzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:55:37 -0500
From: Amit Shah <amit.shah@qumranet.com>
Organization: Qumranet Technologies
To: kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] Guest kernel hangs in smp kvm for older kernels prior to tsc sync cleanup
Date: Wed, 19 Dec 2007 22:25:53 +0530
User-Agent: KMail/1.9.6
Cc: "Glauber de Oliveira Costa" <glommer@gmail.com>,
       "Avi Kivity" <avi@argo.co.il>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>, Gerd Hoffmann <kraxel@redhat.com>
References: <47680173.6060606@qumranet.com> <47692A47.4040803@argo.co.il> <5d6222a80712190732h515a63e6y49c64c0f572f044@mail.gmail.com>
In-Reply-To: <5d6222a80712190732h515a63e6y49c64c0f572f044@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712192225.53748.amit.shah@qumranet.com>
X-OriginalArrivalTime: 19 Dec 2007 16:55:36.0136 (UTC) FILETIME=[F9DC7480:01C8425F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 December 2007 21:02:06 Glauber de Oliveira Costa wrote:
> On Dec 19, 2007 12:27 PM, Avi Kivity <avi@argo.co.il> wrote:
> > Ingo Molnar wrote:
> > > * Avi Kivity <avi@qumranet.com> wrote:
> > >> Avi Kivity wrote:
> > >>>  Testing shows wrmsr and rdtsc function normally.
> > >>>
> > >>> I'll try pinning the vcpus to cpus and see if that helps.
> > >>
> > >> It does.
> > >
> > > do we let the guest read the physical CPU's TSC? That would be trouble.
> >
> > vmx (and svm) allow us to add an offset to the physical tsc.  We set it
> > on startup to -tsc (so that an rdtsc on boot would return 0), and
> > massage it on vcpu migration so that guest rdtsc is monotonic.
> >
> > The net effect is that tsc on a vcpu can experience large forward jumps
> > and changes in rate, but no negative jumps.
>
> Changes in rate does not sound good. It's possibly what's screwing up
> my paravirt clock implementation in smp.

Do you mean in the case of VM migration, or just starting them on a single 
host?

> Since the host updates guest time prior to putting vcpu to run, two
> vcpus that start running at different times will have different system
> values.
>
> Now if the vcpu that started running later probes the time first,
> we'll se the time going backwards. A constant tsc rate is the only way
> around
> my limited mind sees around the problem (besides, obviously, _not_
> making the system time per-vcpu).
