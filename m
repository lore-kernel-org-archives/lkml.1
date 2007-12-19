Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbXLSRFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbXLSRFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 12:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbXLSRFC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 12:05:02 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:57202 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbXLSRFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 12:05:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=b24oX/49lr3fqZQqMczNdyeSieaYYfLFCu7UnYFgOVZXXwF9tsCrMoJjkSOeyusWjbIe8dXzsSdyFkcGvekKTIKDx0IzkKbf7Fk8c3luGT1p+Ii8zDcxiRFJHoO5TsgEj38bqGBvfYKHZ3X7tOCpHUk2Ln/2pmEo7fr3QKGGczw=
Message-ID: <47694F35.6070401@qumranet.com>
Date: Wed, 19 Dec 2007 19:04:53 +0200
Reply-To: dor.laor@qumranet.com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Amit Shah <amit.shah@qumranet.com>
CC: kvm-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@argo.co.il>, Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [kvm-devel] Guest kernel hangs in smp kvm for older kernelsprior
 to tsc sync cleanup
References: <47680173.6060606@qumranet.com> <47692A47.4040803@argo.co.il><5d6222a80712190732h515a63e6y49c64c0f572f044@mail.gmail.com> <200712192225.53748.amit.shah@qumranet.com>
In-Reply-To: <200712192225.53748.amit.shah@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Dor Laor <dor.laor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah wrote:
>
> On Wednesday 19 December 2007 21:02:06 Glauber de Oliveira Costa wrote:
> > On Dec 19, 2007 12:27 PM, Avi Kivity <avi@argo.co.il> wrote:
> > > Ingo Molnar wrote:
> > > > * Avi Kivity <avi@qumranet.com> wrote:
> > > >> Avi Kivity wrote:
> > > >>>  Testing shows wrmsr and rdtsc function normally.
> > > >>>
> > > >>> I'll try pinning the vcpus to cpus and see if that helps.
> > > >>
> > > >> It does.
> > > >
> > > > do we let the guest read the physical CPU's TSC? That would be 
> trouble.
> > >
> > > vmx (and svm) allow us to add an offset to the physical tsc.  We 
> set it
> > > on startup to -tsc (so that an rdtsc on boot would return 0), and
> > > massage it on vcpu migration so that guest rdtsc is monotonic.
> > >
> > > The net effect is that tsc on a vcpu can experience large forward 
> jumps
> > > and changes in rate, but no negative jumps.
> >
> > Changes in rate does not sound good. It's possibly what's screwing up
> > my paravirt clock implementation in smp.
>
> Do you mean in the case of VM migration, or just starting them on a single
> host?
>
It's the cpu preemption stuff on local host and not VM migration
>
> > Since the host updates guest time prior to putting vcpu to run, two
> > vcpus that start running at different times will have different system
> > values.
> >
> > Now if the vcpu that started running later probes the time first,
> > we'll se the time going backwards. A constant tsc rate is the only way
> > around
> > my limited mind sees around the problem (besides, obviously, _not_
> > making the system time per-vcpu).
>
> -------------------------------------------------------------------------
> SF.Net email is sponsored by:
> Check out the new SourceForge.net Marketplace.
> It's the best place to buy or sell services
> for just about anything Open Source.
> http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
> _______________________________________________
> kvm-devel mailing list
> kvm-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/kvm-devel
>

