Return-Path: <linux-kernel-owner+w=401wt.eu-S1765606AbYCEXM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765606AbYCEXM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932236AbYCEXKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:10:08 -0500
Received: from n2b.bullet.mail.ac4.yahoo.com ([76.13.13.72]:42066 "HELO
	n2b.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933190AbYCEXKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:10:04 -0500
X-Yahoo-Newman-Id: 296803.24042.bm@omp408.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CnQvBu10DT7wJ28dLuGTR+P+fTV6qSJxMqQlEORNAWOpk/w821Bnv8YdUbC9GjrJ8Zs0s7iekI+ao9m1X5nwS1fdt0PMUnJmT9ePxPaQLF96OCLPTU74pf6+5Mc43jF+O3Upn6Yz+AZivEIzWJKUvHJs4QLiAN42h5LYoC2xUNY=  ;
X-YMail-OSG: u8m2juwVM1lYccZ5Oa1CbxbJkOFiBD9NEqAxIhikNftOlShH9AAEOkrLD5FPyrYygjOlzmdeFQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 1/5] vmalloc: do not check for freed locks on user maps
Date: Thu, 6 Mar 2008 09:56:43 +1100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
References: <20080305154829.185609547@linutronix.de> <200803060328.20349.nickpiggin@yahoo.com.au> <alpine.LFD.1.00.0803051803070.3099@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0803051803070.3099@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803060956.43671.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2008 04:20, Thomas Gleixner wrote:
> On Thu, 6 Mar 2008, Nick Piggin wrote:
> > On Thursday 06 March 2008 03:03, Thomas Gleixner wrote:
> > > User maps do not contain kernel internal objects. No need to check
> > > them.
> >
> > Why not? Depends on your definition of kernel internal... and
> > objects ;)
> >
> > Drivers could create and manage some objects in this vmalloc
> > area. They are no longer internal if you map them to userspace,
> > but I still don't think you want to vunmap it until those
> > object lifetimes are finished.
>
> Well, in case of the locks I have a hard time to figure out how you
> use a spinlock/mutex with a user space address. The same applies for
> timers or other objects used by kernel subsystems. So when the driver
> writer creates an kernel related object in the vmalloc space, he has
> to use the kernel mapping which is unmapped separate, right ?

This is the kernel mapping. The user mapping is unmapped when
the userspace munmaps.


> I can see your concern about the infinite stu^H^H^Hcreativity of
> driver writers, but I prefer not to go down that road and provide
> debug infrastructure for absurdities.


