Return-Path: <linux-kernel-owner+w=401wt.eu-S1762016AbZAOHZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762016AbZAOHZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 02:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756408AbZAOHZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 02:25:06 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:23762 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756224AbZAOHZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 02:25:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tHlBKjBsBFj5lvEqMghIT57as3QOF4a63cgELDu5BFWqGosMEQ5/R38LNAWmcoqvSlxADGKaJcrMz37ITNn1WObo/k7+cFk7M6Pindudw1310dH1tEjffVRAXgF9lLMbHWn6sa4ASbS44zej1G786GLAJLVxRaxe/SYF+DpE704=  ;
X-YMail-OSG: XJftnTMVM1kZTkP1wCg1RO6ziX8YyjTv7OV3O_bYoDq1aIE1x29JedlSdH.L9P23egbOgpjnf.f9Xgcj.TaRdXfjPVsP67UH83God.fR22Ok1VlkMpVvrycq88EA54_u3wLkDGatczC.EoB4yW3jDDcoYze_ozcSyPMFjDP644GpEIixA9HV.uGF9AMNnbodHAZW56yUllRcAtKF4.jAk_bsDw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Mainline kernel OLTP performance update
Date: Thu, 15 Jan 2009 18:24:36 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Matthew Wilcox <matthew@wil.cx>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>,
       Anirban Chakraborty <anirban.chakraborty@qlogic.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <20090115012147.GW29283@parisc-linux.org> <20090114180431.f4a96543.akpm@linux-foundation.org>
In-Reply-To: <20090114180431.f4a96543.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151824.38658.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009 13:04:31 Andrew Morton wrote:
> On Wed, 14 Jan 2009 18:21:47 -0700 Matthew Wilcox <matthew@wil.cx> wrote:

> > SLUB would have had a huge negative effect if we were using it -- on the
> > order of 7% iirc.  SLQB is at least performance-neutral with SLAB.
>
> We really need to unblock that problem somehow.  I assume that
> enterprise distros are shipping slab?

SLES11 will ship with SLAB, FWIW. As I said in the SLQB thread, this was
not due to my input. But I think it was probably the right choice to make
in that situation.

The biggest problem with SLAB for SGI I think is alien caches bloating the
kmem cache footprint to many GB each on their huge systems, but SLAB has a
parameter to turn off alien caches anyway so I think that is a reasonable
workaround.

Given the OLTP regression, and also I'd hate to have to deal with even
more reports of people's order-N allocations failing... basically with the
regression potential there, I don't think there was a compelling case
found to use SLUB (ie. where does it actually help?).

I'm going to propose to try to unblock the problem by asking to merge SLQB
with a plan to end up picking just one general allocator (and SLOB).

Given that SLAB and SLUB are fairly mature, I wonder what you'd think of
taking SLQB into -mm and making it the default there for a while, to see
if anybody reports a problem?

