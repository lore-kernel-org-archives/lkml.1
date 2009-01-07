Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbZAGCHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbZAGCHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 21:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759348AbZAGCHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 21:07:10 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:32775 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759360AbZAGCHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 21:07:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6jPmVLZck03oMV1UCoXHatKPwOBxJp0byoX4CI4rsdaX5YBjVBF6dCTgnPhpTBSmS+NPvleqqm9XpnI1dZb6YK9r5va9pewEIxv4HGLn3M6Ir0Gj36uh/jCB1eAoJlvntqsk5rexMdh1PQkozmaQm2QZMNfMQsAXhuKuvPxnq/I=  ;
X-YMail-OSG: VqX.uuEVM1ljvIOv23X0pniY03.0gX3TGh8nZ6P4364LPWhbGFsGzDd4VVieiPbT7.o7NY4xG2KJmVBF9vUlcL27sIvwiGbcfUjGuwlDA5IS6GNUZ7q3U2Z6anR3ZENQK1b6GUT6ilqGaQxC6LpcIvcKIU3eOEE_Aje_.U6uaN5ksWXQTMM.9Fc.i8795ZiAmd6bZARtHc.xpGoGw3vuXZOVFwSpU7Zazrw-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.29 -mm merge plans
Date: Wed, 7 Jan 2009 13:06:44 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106151344.0f146286.akpm@linux-foundation.org>
In-Reply-To: <20090106151344.0f146286.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901071306.45210.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 January 2009 10:13:44 Andrew Morton wrote:
> (cc added)
>
> On Tue, 6 Jan 2009 17:57:44 -0500
>
> Christoph Hellwig <hch@infradead.org> wrote:
> > On Mon, Jan 05, 2009 at 12:43:00AM -0800, Andrew Morton wrote:
> > > softirq-introduce-statistics-for-softirq.patch
> > > proc-export-statistics-for-softirq-to-proc.patch
> > > proc-update-document-for-proc-softirqs-and-proc-stat.patch
> >
> > Why is this in procfs?
>
> softirq stuff in /proc seems appropriate?  It's alongside
> /proc/interrupts.  We could put it in /trendy-fs-of-the-day, but what
> would it gain us?

Haven't we kind of agreed to use sysfs for things like this? A few years
too late to be raising objections now ;)

One problem I have with sysfs is that it (the directory structure, rather
than the sysfs code itself) really needs to be policed and maintained
by a central and coherent place/person with taste. Otherwise people put
their own random crap with their own random naming schemes and becomes
a crazy mess.

softirqs are not hardware but purely kernel subsystem construct, as such
they probably go under /sys/kernel/. People unfortunately have already
added random crap to the /sys/kernel/ root directory, but future additions
really should go into a good subdirectory structure (putting it into the
root directory is equivalent to ditching all subdirectories from /proc/sys/).

/sys/kernel/softirq/*, I suggest.


