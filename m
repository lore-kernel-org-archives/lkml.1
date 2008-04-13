Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYDMSTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYDMSTZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbYDMSTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:19:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:51545 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbYDMSTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:19:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Beo4uML8DdqHtPxDadJz8iXD5t2mimtopGpnJBbOLCrkFSnJMvzzblRec0uzH1uBbSWbEB56GXek6qBfx71uMtW0ujhn6Wf+aaZRSF5SHzevx40tgf467tT4NcK8qr3wWAwEKcZv+evqVsJhuB7Ef+azfmuSREKGLizPQItwoCY=
Message-ID: <86802c440804131119m1c43497bg1864ce9751438e85@mail.gmail.com>
Date: Sun, 13 Apr 2008 11:19:06 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [rfc] hw resource debugging checks
Cc: "Ingo Molnar" <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Thomas Gleixner" <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
In-Reply-To: <87d4ouw0u9.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804102159.14563.rjw@sisk.pl> <20080410203800.GA14560@elte.hu>
	 <200804110028.22290.rjw@sisk.pl> <200804112126.29455.rjw@sisk.pl>
	 <20080413075845.GJ20332@elte.hu> <87d4ouw0u9.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 2:39 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Ingo Molnar <mingo@elte.hu> writes:
>
>  This whole problem just shows that it was a mistake in the first place
>  to try to redo the BIOS work in Linux. If BIOS doesn't supply MCFG
>  Linux trying to create one (or in general having generalized resource
>  allocation) is just a big mess and will cause endless problems.  The
>  standard resource code is just not up to the task and it needs very
>  intimate knowledge of the hardware that the kernel shouldn't have.
>
>  Again the real fix I think is to just drop all that code in git-x86
>  again and finally fix LinuxBIOS to do its job properly and pass a
>  proper MCFG (or just forget about using mmconfig with LinuxBIOS - it
>  is not that Type1 suddently doesn't work anymore). Then this code
>  wouldn't be needed at all

It has nothing to LinuxBIOS.

we would trust HW pci conf/msr than BIOS. even I could talk to BIOS
engineers everyday and tell them how to fix the problem in BIOS,  some
still can not be fixed because of the legacy BIOS framework or big
mess.

the patchset from me in x86.git is in two folders
1. MCFG fix up for AMD cpu.
2. BUS numa support for AMD cpu with several sockets with muliti ht
links aka. multi peer root buses.
    it will try to split root resource (iomem_resource, io_resource)
to different ht links. so when kernel try to assign resource to some
unassigned devices, it can use correct values.

these two patches will not hurt intel platform too.

YH
