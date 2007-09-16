Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbXIQNmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbXIQNmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 09:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXIQNmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 09:42:11 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:35236 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754078AbXIQNmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 09:42:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=43k4Ymyyyv2ms04h0Mhfm/mV5z2QTjEFSXrSva3HOAeRCuEHl5XI+2fMmdJKThX0KO6FZ8CFuIpV4u3yKFYbwdDFpEcXKipcBeZ/W3wzrij62pAlk8FhNbmOp5upVu7vsK/muTLzKle5njnNxgiqNdHvu0AgN6Iy5p9E0a5bcQE=  ;
X-YMail-OSG: CkQjH2cVM1nisKfqFnLrVbr._d_2IOBOomXsppySZJ0_VOg67IeB024d2F3GknbU.Rj9eNijwQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH 001/104] KVM: Fix *nopage() in kvm_main.c
Date: Mon, 17 Sep 2007 07:29:24 +1000
User-Agent: KMail/1.9.5
Cc: Christoph Hellwig <hch@infradead.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Nguyen Anh Quynh <aquynh@gmail.com>
References: <11900179463203-git-send-email-avi@qumranet.com> <46EE45C3.8040302@qumranet.com> <46EE4683.7070205@qumranet.com>
In-Reply-To: <46EE4683.7070205@qumranet.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709170729.24835.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 September 2007 19:18, Avi Kivity wrote:
> Avi Kivity wrote:
> > Christoph Hellwig wrote:
> >> On Mon, Sep 17, 2007 at 10:30:43AM +0200, Avi Kivity wrote:
> >>> From: Nguyen Anh Quynh <aquynh@gmail.com>
> >>>
> >>> *nopage() in kvm_main.c should only store the type of mmap() fault if
> >>> the pointers are not NULL. This patch fixes the problem.
> >>
> >> Care to convert it to ->faul while you're at it?
> >
> > I'll add this to my todo, though not sure It'll be in time for .24.  If
> > someone sends a patch I'll apply it.
>
> I should mention that the converting to use ->fault() is a 15-minute
> change; the tricky part is adding backwards compatibility for the
> external module package.

It should be mostly possible to ifdef a nopage() handler, which is
just a wrapper function to translate arguments then call your new
->fault() handler. With luck, fault would mostly inline into nopage,
and do some constant folding to make it cheaper...

I'm planning to go through and convert the rest of the in-tree users
at some point soon, so if you do get a chance to convert your
upstream code before I try, it would nice ;)

Thanks,
Nick
