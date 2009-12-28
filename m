Return-Path: <linux-kernel-owner+w=401wt.eu-S1751436AbZL1P7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbZL1P7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 10:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZL1P67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 10:58:59 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:53484 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZL1P67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 10:58:59 -0500
MIME-Version: 1.0
Message-ID: <f4ab13eb-daaa-40be-82ad-691505b1f169@default>
Date: Mon, 28 Dec 2009 07:57:28 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Nitin Gupta <ngupta@vflare.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, jeremy@goop.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       Rusty Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
       dave.mccracken@oracle.com, sunil.mushran@oracle.com,
       Avi Kivity <avi@redhat.com>, Schwidefsky <schwidefsky@de.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, chris.mason@oracle.com,
       linux-mm <linux-mm@kvack.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: Tmem [PATCH 0/5] (Take 3): Transcendent memory
In-Reply-To: <20091225191848.GB8438@elf.ucw.cz>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B38D585.0168:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Pavel Machek [mailto:pavel@ucw.cz]
> > > As I mentioned, I really like the idea behind tmem. All I 
> am proposing
> > > is that we should probably explore some alternatives to 
> achive this using
> > > some existing infrastructure in kernel.
> > 
> > Hi Nitin --
> > 
> > Sorry if I sounded overly negative... too busy around the holidays.
> > 
> > I'm definitely OK with exploring alternatives.  I just think that
> > existing kernel mechanisms are very firmly rooted in the notion
> > that either the kernel owns the memory/cache or an asynchronous
> > device owns it.  Tmem falls somewhere in between and is very
> 
> Well... compcache seems to be very similar to preswap: in preswap case
> you don't know if hypervisor will have space, in ramzswap you don't
> know if data are compressible.

Hi Pavel --

Yes there are definitely similarities too.  In fact, I started
prototyping preswap (now called frontswap) with Nitin's
compcache code.  IIRC I ran into some problems with compcache's
difficulties in dealing with failed "puts" due to dynamic
changes in size of hypervisor-available-memory.

Nitin may have addressed this in later versions of ramzswap.

One feature of frontswap which is different than ramzswap is
that frontswap acts as a "fronting store" for all configured
swap devices, including SAN/NAS swap devices.  It doesn't
need to be separately configured as a "highest priority" swap
device.  In many installations and depending on how ramzswap
is configured, this difference probably doesn't make much
difference though.

Thanks,
Dan
