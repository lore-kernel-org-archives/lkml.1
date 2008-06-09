Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbYFIVHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbYFIVHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYFIVG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:06:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928AbYFIVGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:06:55 -0400
Message-ID: <484D9A72.4010004@redhat.com>
Date: Mon, 09 Jun 2008 18:02:42 -0300
From: Glauber Costa <gcosta@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, hugh@veritas.com
Subject: Re: [PATCH 11/15] x86: move enabling of io_apic to prepare_cpus
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com> <1213021018-14159-2-git-send-email-gcosta@redhat.com> <1213021018-14159-3-git-send-email-gcosta@redhat.com> <1213021018-14159-4-git-send-email-gcosta@redhat.com> <1213021018-14159-5-git-send-email-gcosta@redhat.com> <1213021018-14159-6-git-send-email-gcosta@redhat.com> <1213021018-14159-7-git-send-email-gcosta@redhat.com> <1213021018-14159-8-git-send-email-gcosta@redhat.com> <1213021018-14159-9-git-send-email-gcosta@redhat.com> <1213021018-14159-10-git-send-email-gcosta@redhat.com> <1213021018-14159-11-git-send-email-gcosta@redhat.com> <1213021018-14159-12-git-send-email-gcosta@redhat.com> <Pine.LNX.4.55.0806091620250.26593@cliff.in.clinika.pl> <484D8813.4040807@redhat.com> <Pine.LNX.4.55.0806092058550.26593@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0806092058550.26593@cliff.in.clinika.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Mon, 9 Jun 2008, Glauber Costa wrote:
> 
>> This one does enable_IO_APIC in the init_uniprocessor too, and should 
>> account for the !smp case.
> 
>  Hmm, it looks a little bit better, but why do you want to call
> enable_IO_APIC() separately in the first place?  There is a comment
> stating: "Enable IO APIC before setting up error vector," but why is it
> needed on 64-bit systems?  Especially as the very same system may run a
> 32-bit kernel and then it suddenly would not have to do this anymore?  
> Strange...

This was reported by Yinghai, but I think he already answered to that.

>  Also since you are cleaning up this code -- why don't you actually take
> the opportunity and get rid of the horrible #ifdefs interspersed
> throughout?
throughout where?
They're all over the place ;)

My next target would be per-cpu data. But that's because there's _a lot_ 
of code in the tree that got ifdefs between 32 and 64-bit because of 
differences in that, specially irq statistics. A macro would do, but if 
we're gonna do it, let's do it right.

