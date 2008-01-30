Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbYA3FRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbYA3FRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 00:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYA3FRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 00:17:04 -0500
Received: from hu-out-0506.google.com ([72.14.214.227]:44062 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbYA3FRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 00:17:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=a3xSEuM6jO42q6NDHZaxKtQXE2lNTmnYj3lYZupGTUd054VccVwbbjgwaQBUPRS1g9tthS1vydPk4ivIR8y/ReWRHZGH+elF52bi1bry+R7uQaOxm41ezZIeLjZ6NH7T8UzOxNntQ1hPQ2sJK96F6AwSXe48l1vlb2eZw61je/A=
Date: Wed, 30 Jan 2008 06:16:10 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, rdreier@cisco.com,
       nai.xia@gmail.com, flo@rfc822.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, j-nomura@ce.jp.nec.com
Subject: Re: kernel BUG at ide-cd.c:1726 in 2.6.24-03863-g0ba6c33 &&
	-g8561b089
Message-ID: <20080130051610.GF10609@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, rdreier@cisco.com,
	nai.xia@gmail.com, flo@rfc822.org, linux-kernel@vger.kernel.org,
	jens.axboe@oracle.com, j-nomura@ce.jp.nec.com
References: <200801292201.45718.nai.xia@gmail.com> <adar6g0e0g2.fsf@cisco.com> <20080129.182356.70224412.k-ueda@ct.jp.nec.com> <200801300058.33284.bzolnier@gmail.com> <20080130050347.GC10609@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080130050347.GC10609@gollum.tnic>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 06:03:47AM +0100, Borislav Petkov wrote:
> On Wed, Jan 30, 2008 at 12:58:33AM +0100, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Hi,
> > 
> > On Wednesday 30 January 2008, Kiyoshi Ueda wrote:
> > > Hi Bart, 
> > > 
> > > On Tue, 29 Jan 2008 14:22:53 -0800, Roland Dreier wrote:
> > > > Hi, I saw the same BUG from ide-cd on one of my systems.  I applied
> > > > the debugging patch to replace the BUG with blk_dump_rq_flags(), and I
> > > > got the output below (full boot log and .config attached to this
> > > > email).
> > > > 
> > > > Please let me know if there's anything else that would help debug the
> > > > problem.
> > > 
> > > Thank you for the information, Roland.
> > > 
> > >  
> > > > [    4.072271] Uniform CD-ROM driver Revision: 3.20
> > > > [    4.098236] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
> > > > [    4.100269]
> > > > [    4.100269] sector 1949759, nr/cnr 0/0
> > > > [    4.100269] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d8
> > > > [    4.100269] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> > > > [    4.101005] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
> > > > [    4.104269]
> > > > [    4.104269] sector 1949759, nr/cnr 0/0
> > > > [    4.104269] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d2
> > > > [    4.104269] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> > > > [    4.109203] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
> > > > [    4.112270]
> > > > [    4.112270] sector 1949759, nr/cnr 0/0
> > > > [    4.112270] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d8
> > > > [    4.112270] cdb: 12 01 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> > > > [    4.112945] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
> > > > [    4.116270]
> > > > [    4.116270] sector 1949759, nr/cnr 0/0
> > > > [    4.116270] bio ffff8102418cc600, biotail ffff8102418cc600, buffer 0000000000000000, d2
> > > > [    4.116270] cdb: 12 01 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
> > > 
> > > Bart,
> > > This means that the rq still has a bio even after DRQ_STAT is cleared.
> > > The original ide-cd code was calling only end_that_request_last() there.
> > > So I thought that the rq should have no bio when DRQ_STAT is cleared,
> > > otherwise the bio leaks.
> > > 
> > > Was my understanding wrong and is that correct behavior in ide-cd?
> > 
> > Added Borislav to cc:.
> > 
> > PS I'm extremely busy with "real-life" (unfortunately IDE hacking is not
> > my paid job) and the friday is the earliest date on which I would be able
> > to look in detail into this problem and other outstanding IDE stuff, sorry.
> 
> Same here, will be able to look into it tomorrow. In the meantime, can someone
> direct me the full BUG() output?

Nevermind. Got it, thanks.

-- 
Regards/Gruﬂ,
    Boris.
