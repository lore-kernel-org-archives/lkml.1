Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbYJDA21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbYJDA21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 20:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYJDA2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 20:28:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:40277 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbYJDA2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 20:28:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,359,1220252400"; 
   d="scan'208";a="387364330"
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "akataria@vmware.com" <akataria@vmware.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
       Zach Amsden <zach@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Fri, 3 Oct 2008 17:27:53 -0700
Subject: RE: [RFC] CPUID usage for interaction between Hypervisors	and	Linux.
Thread-Topic: [RFC] CPUID usage for interaction between Hypervisors	and
	Linux.
Thread-Index: AcklsJCmACCHyGfiTueFVBzXAFLCyAAAU9IA
Message-ID: <0B53E02A2965CE4F9ADB38B34501A3A15DCBA325@orsmsx505.amr.corp.intel.com>
References: <1222881242.9381.17.camel@alok-dev1>
	 <48E3B19D.6060905@zytor.com> <1222882431.9381.23.camel@alok-dev1>
	 <48E3BC21.4080803@goop.org> <1222895153.9381.69.camel@alok-dev1>
 <48E3FDD5.7040106@zytor.com>
 <0B53E02A2965CE4F9ADB38B34501A3A15D927EA4@orsmsx505.amr.corp.intel.com>
 <48E422CA.2010606@zytor.com>
 <0B53E02A2965CE4F9ADB38B34501A3A15DCBA221@orsmsx505.amr.corp.intel.com>
 <48E6AB15.8060405@zytor.com>
In-Reply-To: <48E6AB15.8060405@zytor.com>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha id m940SVdq021965

On 10/3/2008 4:30:29 PM, H. Peter Anvin wrote:
> Nakajima, Jun wrote:
> > What it means their hypervisor returns the interface signature (i.e.
> > "Hv#1"), and that defines the interface. If we use "Lv_1", for
> > example, we can define the interface 0x40000002 through 0x400000FF for Linux.
> > Since leaf 0x40000000 and 0x40000001 are separate, we can decouple
> > the hypervisor vender from the interface it supports.
>
> Right so far.
>
> > This also allows a hypervisor to support multiple interfaces.
>
> Wrong.
>
> This isn't a two-way interface.  It's a one-way interface, and it
> *SHOULD BE*; exposing different information depending on what is
> running is a hack that is utterly tortorous at best.

What I mean is that a hypervisor (with a single vender id) can support multiple interfaces, exposing a single interface to each guest that would expect a specific interface at runtime.

>
> >
> > In fact, both Xen and KVM are using the leaf 0x40000001 for
> > different purposes today (Xen: Xen version number, KVM: KVM
> > para-virtualization features). But I don't think this would break
> > their existing binaries mainly because they would need to expose the interface explicitly now.
> >
> > > > > This further underscores my belief that using 0x400000xx for
> > > > > anything "standards-based" at all is utterly futile, and that
> > > > > this space should be treated as vendor identification and the
> > > > > rest as vendor-specific. Any hope of creating a standard
> > > > > that's actually usable needs to be outside this space, e.g. in
> > > > > the 0x40SSSSxx space I proposed earlier.
> > > > Actually I'm not sure I'm following your logic. Are you saying
> > > > using that 0x400000xx for anything "standards-based" is utterly
> > > > futile because Microsoft said "the range is hypervisor
> > > > vendor-neutral"? Or you were not sure what they meant there. If
> > > > we are not clear, we can ask them.
> > > >
> > > What I'm saying is that Microsoft is effectively squatting on the
> > > 0x400000xx space with their definition.  As written, it's not even
> > > clear that it will remain consistent between *their own*
> > > hypervisors, even less anyone else's.
> >
> > I hope the above clarified your concern. You can google-search a
> > more detailed public spec. Let me know if you want to know a specific URL.
> >
>
> No, it hasn't "clarified my concern" in any way.  It's exactly
> *underscoring* it.  In other words, I consider 0x400000xx unusable for
> anything that is standards-based.  The interfaces everyone is
> currently using aren't designed to export multiple interfaces; they're
> designed to tell the guest which *one* interface is exported.  That is
> fine, we just need to go elsewhere.
>
>         -hpa

What's the significance of supporting multiple interfaces to the same guest simultaneously, i.e. _runtime_? We don't want the guests to run on such a literarily Frankenstein machine. And practically, such testing/debugging would be good only for Halloween :-).

The interface space can be distinct, but the contents are defined and implemented independently, thus you might find overlaps, inconsistency, etc. among the interfaces. And why is runtime "multiple interfaces" required for a standards-based interface?

             .
Jun Nakajima | Intel Open Source Technology Center
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
