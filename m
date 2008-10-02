Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbYJBBLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbYJBBLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 21:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYJBBLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 21:11:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:12074 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbYJBBLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 21:11:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,347,1220252400"; 
   d="scan'208";a="342802909"
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
       "akataria@vmware.com" <akataria@vmware.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
       Zach Amsden <zach@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Wed, 1 Oct 2008 18:11:11 -0700
Subject: RE: [RFC] CPUID usage for interaction between Hypervisors	and	Linux.
Thread-Topic: [RFC] CPUID usage for interaction between Hypervisors	and
	Linux.
Thread-Index: AckkGBE4TXNYZkinTcGGS4pMLh4WkAADaueQ
Message-ID: <0B53E02A2965CE4F9ADB38B34501A3A15D927EA4@orsmsx505.amr.corp.intel.com>
References: <1222881242.9381.17.camel@alok-dev1>
	 <48E3B19D.6060905@zytor.com> <1222882431.9381.23.camel@alok-dev1>
	 <48E3BC21.4080803@goop.org> <1222895153.9381.69.camel@alok-dev1>
 <48E3FDD5.7040106@zytor.com>
In-Reply-To: <48E3FDD5.7040106@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m921Bpdq024490

On 10/1/2008 3:46:45 PM, H. Peter Anvin wrote:
> Alok Kataria wrote:
> > > No, that's always a terrible idea.  Sure, its necessary to deal
> > > with some backward-compatibility issues, but we should even
> > > consider a new interface which assumes this kind of thing.  We
> > > want properly enumerable interfaces.
> >
> > The reason we still have to do this is because, Microsoft has
> > already defined a CPUID format which is way different than what you
> > or I are proposing ( with the current case of 256 leafs being
> > available). And I doubt they would change the way they deal with it on their OS.
> > Any proposal that we go with, we will have to export different CPUID
> > interface from the hypervisor for the 2 OS in question.
> >
> > So i think this is something that we anyways will have to do and not
> > worth binging about in the discussion.
>
> No, that's a good hint that what "you and I" are proposing is utterly
> broken and exactly underscores what I have been stressing about
> noncompliant hypervisors.
>
> All I have seen out of Microsoft only covers CPUID levels 0x40000000
> as an vendor identification leaf and 0x40000001 as a "hypervisor
> identification leaf", but you might have access to other information.

No, it says "Leaf 0x40000001 as hypervisor vendor-neutral interface identification, which determines the semantics of leaves from 0x40000002 through 0x400000FF." The Leaf 0x40000000 returns vendor identifier signature (i.e. hypervisor identification) and the hypervisor CPUID leaf range, as in the proposal.

>
> This further underscores my belief that using 0x400000xx for anything
> "standards-based" at all is utterly futile, and that this space should
> be treated as vendor identification and the rest as vendor-specific.
> Any hope of creating a standard that's actually usable needs to be
> outside this space, e.g. in the 0x40SSSSxx space I proposed earlier.
>

Actually I'm not sure I'm following your logic. Are you saying using that 0x400000xx for anything "standards-based" is utterly futile because Microsoft said "the range is hypervisor vendor-neutral"? Or you were not sure what they meant there. If we are not clear, we can ask them.


>         -hpa
             .
Jun Nakajima | Intel Open Source Technology Center
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
