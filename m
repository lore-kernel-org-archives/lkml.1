Return-Path: <linux-kernel-owner+w=401wt.eu-S1753749AbZAFPFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbZAFPFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 10:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZAFPFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 10:05:45 -0500
Received: from relay2.sgi.com ([192.48.179.30]:60348 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751944AbZAFPFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 10:05:44 -0500
Message-ID: <49637346.6060105@sgi.com>
Date: Tue, 06 Jan 2009 07:05:42 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Jack Steiner <steiner@sgi.com>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       Cliff Wickman <cpw@sgi.com>, Russ Anderson <rja@sgi.com>
Subject: Re: [patch] x86: make UV support optional
References: <20090106060348.GA16738@wotan.suse.de> <20090106143330.GB18913@sgi.com> <20090106144843.GH16738@wotan.suse.de>
In-Reply-To: <20090106144843.GH16738@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Tue, Jan 06, 2009 at 08:33:30AM -0600, Jack Steiner wrote:
>> On Tue, Jan 06, 2009 at 07:03:48AM +0100, Nick Piggin wrote:
>>> UV is fairly rare.... and much of the support is already there to cope with
>>> 32-bit builds. So this makes sense I think.

What, you haven't heard of "UV on a chip"?  It will be in every
smart phone soon... ;-)

>>>
>>
>> Looks ok to me. One suggestion though. There is a MAXSMP config
>> option. I would suggest enabling UV if MAXSMP is enabled. This
>> will help ensure that UV is tested more frequently & may minimize
>> regressions.
> 
> Yeah.... I don't know. OTOH it would be more logical to enable
> MAXSMP iff UV is enabled (or change the MAXSMP limits for when
> UV is enabled). Or you could select Intel CPUs if UV is enabled,
> or disable GRU if UV is not set etc etc.
> 
> I didn't want to get too fancy with config options because arbitrary
> linkages seem to just cause headaches. I figure if someone wants
> to enable it, they can do so.
> 

Hi Nick,

The problem arises that if the option becomes too obscure (and never
enabled), then it won't get tested.  We (as many companies do) rely on
distros to certify applications and security features using a standard
kernel, and if an option (such as X86_UV) causes any problems whatsoever,
they'll drop it and we no longer have that application certification.

Currently, Ingo's test setup sets MAXSMP quite a bit and he's found
many problems with large NR_CPUS counts that we never would have found
ourselves.  Please don't make that process any harder.

In fact, 13k is peanuts.  Why don't you set something like "very minimal
support" and drop all obsolete features, anything older than a couple of
years, anything not available from Dell ;-)  Perhaps call it "Desktop
System"?

Thanks,
Mike
