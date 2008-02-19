Return-Path: <linux-kernel-owner+w=401wt.eu-S1762120AbYBSUsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762120AbYBSUsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 15:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbYBSUr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 15:47:58 -0500
Received: from server54.tchmachines.com ([72.9.244.106]:51800 "EHLO
	server54.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbYBSUr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 15:47:57 -0500
X-Greylist: delayed 2804 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2008 15:47:56 EST
Date: Tue, 19 Feb 2008 11:59:52 -0800
From: Ravikiran Thirumalai <kiran@scalemp.com>
To: Glauber Costa <glommer@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Glauber Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, ak@suse.de,
       chrisw@sous-sol.org, shai@scalemp.com
Subject: Re: [PATCH 4/5] [PATCH] introduce paravirt helpers
Message-ID: <20080219195951.GU6209@localdomain>
References: <1202757365-18634-1-git-send-email-gcosta@redhat.com> <1202757365-18634-2-git-send-email-gcosta@redhat.com> <1202757365-18634-3-git-send-email-gcosta@redhat.com> <1202757365-18634-4-git-send-email-gcosta@redhat.com> <20080217180509.GW6006@elte.hu> <5d6222a80802171256l6e178eb8h1080bfd5a6b95ef3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d6222a80802171256l6e178eb8h1080bfd5a6b95ef3@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server54.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 06:56:56PM -0200, Glauber Costa wrote:
>On Feb 17, 2008 4:05 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> * Glauber Costa <gcosta@redhat.com> wrote:
>>
>> >  config X86_VSMP
>> >       bool "Support for ScaleMP vSMP"
>> >       depends on X86_64 && PCI
>> > -      help
>> > +     select PARAVIRT
>> > +     help
>>
>> hm, what's the idea here?
>
>guys from scalemp can probably give a better picture if needed,
>but in a nutshell, there are two aspects involved with the vsmp
>support. The first one
>is special L1 alignments, and the second, specialized irq handling routines.
>
>Only the second one is paravirt in itself, and are the ones addressed
>in this patch.
>The specialized routines now goes through paravirt ops. So when using
>a vsmp machine,
>paravirt has to be selected, in order to enable such functions.

Thanks Glauber.  Well put.

That said, future revs of vSMP will have the ability to work optimally even
without the paravirtualized irq ops.  This is an upcoming feature, and did not
exist when we tested the paravirt ops 2-3 months ago.  So, it will be
better, now, not to select PARAVIRT while selecting X86_VSMP.  Then,
CONFIG_VSMP will just select the cacheline padding to be used and PARAVIRT
will be needed if irq operations need to be paravirtualized.

I shall submit a patch to that effect.

Thanks,
Kiran
