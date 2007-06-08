Return-Path: <linux-kernel-owner+w=401wt.eu-S969617AbXFHQFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969617AbXFHQFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965798AbXFHQFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:05:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:59271 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763697AbXFHQFd (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:05:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=khyAB4iU9HhhbKUQZkaENIBMyXOIb+LOeaKHWjQcfSRok15VTDaOsZLHqqZnc/42vC5EL5FoNEgMQ+24rzODd6kqwiiOBpwmFspifHVY6yxYPgRFQF51NCeV3ztR+/9UE3/UqXuUNtLxcprznleyeu2skmcf3JYEFJizWympaSw=
Message-ID: <6934efce0706080905h253d9e3apd4168c5d14d305e5@mail.gmail.com>
Date: Fri, 8 Jun 2007 09:05:32 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>, carsteno@de.ibm.com,
       "Jared Hulbert" <jaredeh@gmail.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       "Richard Griffiths" <res07ml0@verizon.net>,
       Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
In-Reply-To: <20070608080401.GA17684@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070606113351.GA11701@infradead.org>
	 <20070606162305.GA20600@infradead.org> <46683B6A.6030306@de.ibm.com>
	 <20070607193844.GB17144@infradead.org> <4669027E.3070406@de.ibm.com>
	 <20070608072609.GA13115@infradead.org> <46690A39.3010402@de.ibm.com>
	 <20070608075717.GA16927@infradead.org> <46690C58.7090304@de.ibm.com>
	 <20070608080401.GA17684@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/8/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Jun 08, 2007 at 09:59:20AM +0200, Carsten Otte wrote:
> > Christoph Hellwig wrote:
> > >Jared's patch currently does ioremap on mount (and no iounmap at all).
> > >That mapping needs to move from the filesystem to the device driver.
> > The device driver needs to do ioremap on open(), and iounmap() on
> > release. That's effectively what our block driver does.
>
> Yes, exactly.

Okay so we need some driver that opens/closes this ROM.  This has been
done from the dcss block device but that doesn't make sense for most
embedded systems.  The MTD allows for this with point(),unpoint().
That should work just fine.  It does introduce the MTD as a dependancy
which is unnecessary in many systems, but it will work now.
