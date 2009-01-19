Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbZASKEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbZASKEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 05:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758709AbZASKEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 05:04:22 -0500
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:23590 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758714AbZASKEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 05:04:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6HAKHvoRrWaVgzCJuSNYHgQOKREZCF38XlIS3ID6+Yhgu0xUql+D1rk2u3q539xlTnV6KHPWMTrzYHP0OgfmO/wXmT3BDTkCrYINw50uAw8NXOkoYAxggM83EfQ6/t+WKztJd2Y/1P8ggjrk1cSjFgG1wkMXiMaW52C7DLKyvcA=  ;
X-YMail-OSG: llGyd_EVM1mxZMVR7hndkitsmUVG7tC8AB3n1fmd.P.eXPFDzMngFGSYZhx2J6rJkg2exvcMPtDIC.VanR26cXWyjKtGQ9WigTvSsdTw4dw7ngRPSWA1JjkHqeDXJbUckQhssEG4fuugaJHvZr44xOb_uqKBQoHn9F3WDemVs2qwyOWPIT6Rx6mvUUMDqImrCxk_ZuAmLY9dwkxPZzbxiJivKN_JRQ82jfw-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: Mainline kernel OLTP performance update
Date: Mon, 19 Jan 2009 21:03:55 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: "Matthew Wilcox" <matthew@wil.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       "Andrew Vasquez" <andrew.vasquez@qlogic.com>,
       "Anirban Chakraborty" <anirban.chakraborty@qlogic.com>,
       "Christoph Lameter" <cl@linux-foundation.org>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <200901191933.29322.nickpiggin@yahoo.com.au> <84144f020901190148r7ea135b6uead33842e93e59c2@mail.gmail.com>
In-Reply-To: <84144f020901190148r7ea135b6uead33842e93e59c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901192103.57508.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2009 20:48:52 Pekka Enberg wrote:
> Hi Nick,
>
> On Mon, Jan 19, 2009 at 10:33 AM, Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> >> All I am saying is that I don't like how we're fixing a performance bug
> >> with a shiny new allocator without a credible explanation why the
> >> current approach is not fixable.
> >
> > To be honest, my biggest concern with SLUB is the higher order pages
> > thing. But Christoph always poo poos me when I raise that concern, and
> > it's hard to get concrete numbers showing real fragmentation problems
> > when it can take days or months to start biting.
>
> To be fair to SLUB, we do have the pending slab defragmentation
> patches in my tree. Not that we have any numbers on if defragmentation
> helps and how much. IIRC, Christoph said one of the reasons for
> avoiding queues in SLUB is to be able to do defragmentation. But I
> suppose with SLQB we can do the same thing as long as we flush the
> queues before attempting to defrag.

I have had a look at them, (and I raised some concerns about races with
the bufferhead "defragmentation" patch which I didn't get a reply to,
but now's not the time to get into that).

Christoph's design AFAIKS is not impossible with queued slab allocators,
but they would just need to do either some kind of per-cpu processing,
at least a way to flush queues of objects. This should not be impossible.

But in my reply, I also outlined an idea for a possibly better design for
targetted slab reclaim that could have fewer of the locking complexitiesin 
other subsystems like the slub defrag patches do. I plan to look at this
at some point, but I think we need to sort out the basics first.

