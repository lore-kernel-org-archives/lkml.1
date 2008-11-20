Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbYKTTOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbYKTTOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbYKTTNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:13:34 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:34912 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742AbYKTTNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:13:32 -0500
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Jens Axboe <jens.axboe@oracle.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Date: Thu, 20 Nov 2008 19:12:36 +0000
Subject: RE: in 2.6.23-rc3-git7 in do_cciss_intr
Thread-Topic: in 2.6.23-rc3-git7 in do_cciss_intr
Thread-Index: AclLOL0uPwvwkZTKQwitOUyy8i97gAACsshA
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77884EACB7A11D@GVW0547EXC.americas.hpqcorp.net>
References: <4923347D.8000205@oracle.com> <20081119085227.GQ26308@kernel.dk>
 <0F5B06BAB751E047AB5C87D1F77A77884EACB7986A@GVW0547EXC.americas.hpqcorp.net>
 <49244B69.80903@oracle.com>
 <0F5B06BAB751E047AB5C87D1F77A77884EACB798C4@GVW0547EXC.americas.hpqcorp.net>
 <20081119172919.GT26308@kernel.dk>
 <0F5B06BAB751E047AB5C87D1F77A77884EACB799CC@GVW0547EXC.americas.hpqcorp.net>
 <20081119204624.GW26308@kernel.dk> <20081120091303.GF26308@kernel.dk>
 <0F5B06BAB751E047AB5C87D1F77A77884EACB79F52@GVW0547EXC.americas.hpqcorp.net>
 <20081120175029.GM26308@kernel.dk>
In-Reply-To: <20081120175029.GM26308@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jens Axboe [mailto:jens.axboe@oracle.com]
> Sent: Thursday, November 20, 2008 11:51 AM
> To: Miller, Mike (OS Dev)
> Cc: Randy Dunlap; scsi; James Bottomley; lkml; akpm
> Subject: Re: in 2.6.23-rc3-git7 in do_cciss_intr
>
> On Thu, Nov 20 2008, Miller, Mike (OS Dev) wrote:
> > Jens wrote:
> >
> > > >
> > > > I'd propose just converting it to list_head instead of doing it
> > > > manually. Heck, that should be a 5 minute job, let me
> just do it...
> > > >
> > > > OK, here it is, totally untested (it compiles, must be
> golden...)
> > >
> > > It was missing a list_entry() in fail_all_cmds(), apart
> from that it
> > > was fine. I changed it to use hlist instead, as that is more
> > > appropriate and similar to how it worked before. It also means
> > > there's no extra space usage in the controller structure. I've
> > > tested it and it works fine for me.
> > >
> > > Mike, can you give this a look-over and give me a Reviewed-by or
> > > similar? As an extra bonus, it also gets rid of some code.
> > >
> > >  3 files changed, 33 insertions(+), 46 deletions(-)
> > >
> > > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=e303054
> > > e55acd1b6478b8859a5f8648bfaf69a44
> >
> > That works for me. :)
> >
> > Acked-by: Mike Miller <mike.miller@hp.com>
>
> Excellent, thanks Mike. If you could run it through a cycle
> or so of your regular testing, I'd feel 100% confident in it.

Jens,
I'm porting the changes into our build environment so they will go thru the full QA cycle. I'm also testing in my lab before giving the changes to QA.

Thanks for the quick fix.

-- mikem
