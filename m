Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbXLSPl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbXLSPl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 10:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbXLSPlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 10:41:19 -0500
Received: from il.qumranet.com ([82.166.9.18]:33274 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbXLSPlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 10:41:18 -0500
Message-ID: <47693B9D.7080809@qumranet.com>
Date: Wed, 19 Dec 2007 17:41:17 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <glommer@gmail.com>
CC: Avi Kivity <avi@argo.co.il>, Ingo Molnar <mingo@elte.hu>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [kvm-devel] Guest kernel hangs in smp kvm for older kernels prior
 to tsc sync cleanup
References: <47680173.6060606@qumranet.com> <20071218221930.GA26109@elte.hu>	 <4768BB43.1000609@qumranet.com> <4768FE27.7020305@qumranet.com>	 <47690304.1090903@qumranet.com> <20071219140624.GF21282@elte.hu>	 <47692A47.4040803@argo.co.il> <5d6222a80712190732h515a63e6y49c64c0f572f044@mail.gmail.com>
In-Reply-To: <5d6222a80712190732h515a63e6y49c64c0f572f044@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> Changes in rate does not sound good. It's possibly what's screwing up
> my paravirt clock implementation in smp.
>   

You should renew the timebase on vcpu migration, and hook cpufreq so 
that changes in frequency are reflected in the timebase.

> Since the host updates guest time prior to putting vcpu to run, two
> vcpus that start running at different times will have different system
> values.
>
> Now if the vcpu that started running later probes the time first,
> we'll se the time going backwards. A constant tsc rate is the only way
> around
> my limited mind sees around the problem (besides, obviously, _not_
> making the system time per-vcpu).
>   

I tried disabling frequency scaling (rmmod acpi_cpufreq) but that didn't 
help my present problems.

-- 
error compiling committee.c: too many arguments to function

