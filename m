Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbZFBDjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbZFBDjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 23:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbZFBDji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 23:39:38 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:39405 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbZFBDjh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 23:39:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=erctIGBl7yOR34alOooqCx+hgjXMia67EVuZNVSFZBYAKIcI58/FplC6+xvqCechDG
         bF5nZ0AsHXwPIjr0kK3m666BTXOVUwZS5uFQnJOaDYGvXL/isbo3Elpr+HzinePqblEF
         FkTYT1VytOZqSgmBHslwiL8CPE67JBPYMqW4I=
MIME-Version: 1.0
In-Reply-To: <1243900716.11263.42.camel@jstultz-laptop>
References: <200905051956.n45JuVo9025575@imap1.linux-foundation.org> 
	<tip-22cfbbfd9f67b67fe073010f51cb71d3632387d5@git.kernel.org> 
	<1243542817.29511.523.camel@jstultz-laptop> <20090601232223.GH749@elte.hu> 
	<1243900716.11263.42.camel@jstultz-laptop>
From: Ray Lee <madrabbit@gmail.com>
Date: Mon, 1 Jun 2009 20:39:18 -0700
Message-ID: <2c0942db0906012039ha1046abqe32951b57f40c0f4@mail.gmail.com>
Subject: Re: [tip:timers/ntp] ntp: adjust SHIFT_PLL to improve NTP convergence
To: John Stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       riel@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org,
       Miroslav Lichvar <mlichvar@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 1, 2009 at 4:58 PM, John Stultz <johnstul@us.ibm.com> wrote:
> On Tue, 2009-06-02 at 01:22 +0200, Ingo Molnar wrote:
>> * John Stultz <johnstul@us.ibm.com> wrote:
>> > On Wed, 2009-05-06 at 09:46 +0000, tip-bot for john stultz wrote:
>> > > ntp: adjust SHIFT_PLL to improve NTP convergence
>> > >
>> > > The conversion to the ntpv4 reference model
>> > > f19923937321244e7dc334767eb4b67e0e3d5c74 ("ntp: convert to the NTP4
>> > > reference model") in 2.6.19 added nanosecond resolution the adjtimex
>> > > interface, but also changed the "stiffness" of the frequency adjustments,
>> > > causing NTP convergence time to greatly increase.
>> > >
>> > > SHIFT_PLL, which reduces the stiffness of the freq adjustments, was
>> > > designed to be inversely linked to HZ, and the reference value of 4 was
>> > > designed for Unix systems using HZ=100.  However Linux's clock steering
>> > > code mostly independent of HZ.
>> > >
>> > > So this patch reduces the SHIFT_PLL value from 4 to 2, which causes NTPd
>> > > behavior to match kernels prior to 2.6.19, greatly reducing convergence
>> > > times, and improving close synchronization through environmental thermal
>> > > changes.
>> > >
>> > >
>> > > [ Impact: tweak NTP algorithm for faster convergence ]
>> >
>> >     So I've been speaking with Miroslav (cc'ed) who maintains
>> > the RH ntpd packages, and he's concerned that this patch takes us
>> > out of NTP's expected behavior, which may cause problems when
>> > dealing with non-linux systems using NTP.
>>
>> I might be missing something here - but Linux converging faster
>> seems like a genuinely good thing. What non-Linux problem could
>> there be? Linux's convergence is really Linux's private issue.
>
> Yea. It does seem that way. Miroslav can likely expand on the issue to
> help clarify, but as I understand it, the example is if you have a
> number of systems that are peers in an NTP network. All of them are
> using the same userland NTP daemon. However, if the rate of change that
> corrections are applied is different in half of them, you will have
> problems getting all the systems to converge together.

Your point is clear, however -- reasonably speaking --  how many
instances will there be out there of networks of peers partially
upgraded versus lone systems slowly or never converging off of
masters?

By my naive understanding, the latter would strongly outnumber the former.
