Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbXFVRXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbXFVRXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbXFVRXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:23:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:56034 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143AbXFVRXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:23:45 -0400
From: Andi Kleen <ak@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH v2] doc/oops-tracing: add Code: decode info
Date: Fri, 22 Jun 2007 19:23:02 +0200
User-Agent: KMail/1.9.1
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com> <200706221626.39969.ak@suse.de> <20070622094429.0910c7cb.randy.dunlap@oracle.com>
In-Reply-To: <20070622094429.0910c7cb.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706221923.02736.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 June 2007 18:44, Randy Dunlap wrote:
> On Fri, 22 Jun 2007 16:26:39 +0200 Andi Kleen wrote:
> > On Friday 22 June 2007 07:51:08 Randy Dunlap wrote:
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > >
> > > Add info that the Code: bytes line contains <xy> or (wxyz) in some
> > > architecture oops reports and what that means.
> > >
> > > Add URL for a script by Andi Kleen that reads the Code: line from an
> > > Oops report file and generates assembly code from the hex bytes.
> > > (This script does not handle Code: lines that contain <xy> or (wxyz)
> > > markings.)
> >
> > Should probably fix that and put it into scripts/ then
>
> From: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

>
> +*Code:*)
> +	echo $i
> +	echo -n "	.byte 0x" > $T.s
> +	echo $i | sed -e 's/.*Code: //;s/ [<(]/ /;s/[>)] / /;s/ /,0x/g' >> $T.s
> +	as -o $T.o $T.s
> +	objdump -S $T.o

This still has a couple of problems:

- The <> information is lost. It would be better to split and run 
objdump three times and insert a marker
- It won't handle multiline Code:s which i386 likes to generate now I think

-Andi
