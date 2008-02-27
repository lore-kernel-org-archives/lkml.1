Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbYB0GVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbYB0GVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 01:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbYB0GVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 01:21:33 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:18811 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbYB0GVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 01:21:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jxh2UsaFWI/sONW2KMHqd33+6WoyrNPvwGCkkQlITpJ/Qdl6OixLfXNpyeO6JlDGakPAKId0m32zUHQi39E42bnFBTYkpF+lagzSDf7pQ1B1qLIAvIXOL6KtXdQyAz61KA6BCVYTiwCI5sw38eoFPFlEzdR0KwqEy+tkGHPattk=
Message-ID: <86802c440802262221x66f2ccf8s2f290efd184891dd@mail.gmail.com>
Date: Tue, 26 Feb 2008 22:21:31 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "=?ISO-8859-1?Q?Francisco_Jes=FAs_Mart=EDnez_Serrano?=" 
	<franjesus@gmail.com>
Subject: Re: [discuss] Weird cpu mapping on 8-way dual-core machine
Cc: "Andre Przywara" <andre.przywara@amd.com>, discuss@x86-64.org,
       "Andi Kleen" <ak@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440802262148p7cee20bft8a00d14ba8ae1470@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <8e3e1e8e0802250900t782d5c01n79bb7bab22911add@mail.gmail.com>
	 <200802251911.15956.ak@suse.de>
	 <8e3e1e8e0802251055u65796f4dp92e8d2d508313d89@mail.gmail.com>
	 <8e3e1e8e0802260240n28b6045ey7464ab78e8c0ce45@mail.gmail.com>
	 <47C3F0BC.9070401@amd.com>
	 <8e3e1e8e0802260958x7189d0a2ua3037683cdd80705@mail.gmail.com>
	 <86802c440802262148p7cee20bft8a00d14ba8ae1470@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 9:48 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Tue, Feb 26, 2008 at 9:58 AM, Francisco Jesús Martínez Serrano
>  <franjesus@gmail.com> wrote:
>  > 2008/2/26, Andre Przywara:
>  >
>  > >  So your BIOS option disables the shifting workaround and everything
>  >  >  works as intended by the specification, although I am not sure whether
>  >  >  you have any side effects (see above).
>  >
>  >  Maybe I'm getting some side effects, but I'm not sure, when running an
>  >  OpenMP code, I get a lot of numa_misses, at node1 and the same number
>  >  of numa_foreign at node0.
>  >
>  >  Out of pure ignorance, I was wondering if it could be related to the
>  >  node0 getting 505896 pages  (I believe that's 1976.2 MB) of
>  >  ZONE_DMA32. I've seen options to disable DMA and DMA32. Is it safe?
>  >
>  can you try x86.git#testing ?
>
>  http://people.redhat.com/mingo/x86.git/README
>
>  and connect with serial console.
>
>  command line:
>  apic=debug acpi.debug_level=0x0000000F debug console=uart8250,io,0x3f8,115200n8
>
core fix is in x86.git#testing
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commitdiff;h=ae2627a87c6f186ced0539d8e6f7a2c78dabc4c5

it will make sure that apicid to node mapping is right.
esp don't have SRAT or wrong SRAT, and your system have apicid lifting

YH
