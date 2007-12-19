Return-Path: <linux-kernel-owner+w=401wt.eu-S1758954AbXLSPcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954AbXLSPcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 10:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbXLSPcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 10:32:10 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:21506 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbXLSPcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 10:32:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HG2gHO2uA+lGklXmi8NzkEvzf44NYpJsBFlD7hQCJ3aRzUUpsGfFTxbaTzIU0734bPsg8NaGJg/TxsN8KQqc2bKB1cZRmYFD09EY6bXcfDJgnxmzxFo6lVNqYmh/iUnJoXSQO0hRXRLGMJU1LYQK+AOvGLKqApS7Z3jiS6xzul0=
Message-ID: <5d6222a80712190732h515a63e6y49c64c0f572f044@mail.gmail.com>
Date: Wed, 19 Dec 2007 13:32:06 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Avi Kivity" <avi@argo.co.il>
Subject: Re: [kvm-devel] Guest kernel hangs in smp kvm for older kernels prior to tsc sync cleanup
Cc: "Ingo Molnar" <mingo@elte.hu>, "Avi Kivity" <avi@qumranet.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Gerd Hoffmann" <kraxel@redhat.com>
In-Reply-To: <47692A47.4040803@argo.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47680173.6060606@qumranet.com> <20071218221930.GA26109@elte.hu>
	 <4768BB43.1000609@qumranet.com> <4768FE27.7020305@qumranet.com>
	 <47690304.1090903@qumranet.com> <20071219140624.GF21282@elte.hu>
	 <47692A47.4040803@argo.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 19, 2007 12:27 PM, Avi Kivity <avi@argo.co.il> wrote:
> Ingo Molnar wrote:
> > * Avi Kivity <avi@qumranet.com> wrote:
> >
> >
> >> Avi Kivity wrote:
> >>
> >>>  Testing shows wrmsr and rdtsc function normally.
> >>>
> >>> I'll try pinning the vcpus to cpus and see if that helps.
> >>>
> >>>
> >> It does.
> >>
> >
> > do we let the guest read the physical CPU's TSC? That would be trouble.
> >
> >
>
> vmx (and svm) allow us to add an offset to the physical tsc.  We set it
> on startup to -tsc (so that an rdtsc on boot would return 0), and
> massage it on vcpu migration so that guest rdtsc is monotonic.
>
> The net effect is that tsc on a vcpu can experience large forward jumps
> and changes in rate, but no negative jumps.
>

Changes in rate does not sound good. It's possibly what's screwing up
my paravirt clock implementation in smp.
Since the host updates guest time prior to putting vcpu to run, two
vcpus that start running at different times will have different system
values.

Now if the vcpu that started running later probes the time first,
we'll se the time going backwards. A constant tsc rate is the only way
around
my limited mind sees around the problem (besides, obviously, _not_
making the system time per-vcpu).


-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
