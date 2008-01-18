Return-Path: <linux-kernel-owner+w=401wt.eu-S1764972AbYARSqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764972AbYARSqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762841AbYARSqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:46:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:35272 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760734AbYARSqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:46:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,217,1199692800"; 
   d="scan'208";a="504939905"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] X86: fix typo PAT to X86_PAT
Date: Fri, 18 Jan 2008 10:47:05 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE62B7BA@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080118182437.GA10167@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] X86: fix typo PAT to X86_PAT
Thread-Index: AchZ/26f8YY8SXi9TiKh7fqqSXLIGwAAocUA
References: <20080118123140.GI11044@elte.hu> <20080118182437.GA10167@redhat.com>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Dave Jones" <davej@redhat.com>, "Ingo Molnar" <mingo@elte.hu>
Cc: "Yinghai Lu" <Yinghai.Lu@Sun.COM>, "LKML" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Jan 2008 18:46:08.0722 (UTC) FILETIME=[63954320:01C85A02]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Dave Jones [mailto:davej@redhat.com] 
>Sent: Friday, January 18, 2008 10:25 AM
>To: Ingo Molnar
>Cc: Yinghai Lu; Pallipadi, Venkatesh; LKML
>Subject: Re: [PATCH] X86: fix typo PAT to X86_PAT
>
>On Fri, Jan 18, 2008 at 01:31:40PM +0100, Ingo Molnar wrote:
> 
> > * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> >
> > > > thanks. But, i think we should rather do the following: 
>if X86_PAT
> > > > is eanbled then /proc/mtrr should be read-only. There's 
>no problem
> > > > _looking_ at MTRR contents, as long as we do not try to 
>modify them.
> > > > Hm?
> > >
> > > anyway
> > >
> > > depends on !PAT
> > >
> > > need to be removed.
> > >
> > > it seems when PAT is used, some code still touch MTRR.
> >
> > you mean modifies MTRRs? Which code is that? (besides the /proc/mtrr
> > userspace API)
>
>This exclusion is going to be a real pain in the ass for 
>distro kernels.
>It's impossible for example to build a kernel that will now support
>the MTRR-alike registers on the AMD K6/early Cyrix etc and also
>support PAT.
>

Actually, this exclusion will not work at all with the current code.
Infact it should be PAT selects MTRR, for the current code. As
pat_init() is called during mtrr init as the rules for how to change PAT
and how to change MTRR are same. Further, MTRR is always required on
SMP, as we read the MTRR setting from boot CPU and set it on Aps at boot
time. We should only remove the /proc/mtrr write permissions with
CONFIG_PAT. We need to deprecate it for a while before that...
Ingo, can you remove this PAT MTRR exclusion.

Thanks,
Venki 
