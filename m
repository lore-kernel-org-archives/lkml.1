Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbXIRJZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbXIRJZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756239AbXIRJZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:25:33 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:48580 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753462AbXIRJZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:25:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=my0ZNB4uJHvBM7xlSy20kUbQCxow7Hu3A+ytjZb8D3LokUrTAhyf485EtaMDXhjNkxo4nC5yeU3OWSh38/SbkalbadHZAo2gJjBc3ws6R1nYRkO2S0htMoUwttUKv94endk0h/1l9hYCAuP+cWzJUsr1a0YyARkwiftLlfkHkjM=  ;
X-YMail-OSG: DaDNuNcVM1ljHPawtUOlSx2PfCx7hqHmfKLsFYjXHzcHEFbYXgvSBVQpbHXDoK13ABKIS8dWGw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH 001/104] KVM: Fix *nopage() in kvm_main.c
Date: Tue, 18 Sep 2007 03:17:06 +1000
User-Agent: KMail/1.9.5
Cc: Christoph Hellwig <hch@infradead.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Nguyen Anh Quynh <aquynh@gmail.com>
References: <11900179463203-git-send-email-avi@qumranet.com> <200709170729.24835.nickpiggin@yahoo.com.au> <46EEC52B.8080101@qumranet.com>
In-Reply-To: <46EEC52B.8080101@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709180317.07055.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2007 04:19, Avi Kivity wrote:
> Nick Piggin wrote:
> >> I should mention that the converting to use ->fault() is a 15-minute
> >> change; the tricky part is adding backwards compatibility for the
> >> external module package.
> >
> > It should be mostly possible to ifdef a nopage() handler, which is
> > just a wrapper function to translate arguments then call your new
> > ->fault() handler. With luck, fault would mostly inline into nopage,
> > and do some constant folding to make it cheaper...
> >
> > I'm planning to go through and convert the rest of the in-tree users
> > at some point soon, so if you do get a chance to convert your
> > upstream code before I try, it would nice ;)
>
> In kvm I don't add compatibility #ifdefs to mainline, instead I have an
> awk script that massages the sources into something that all kernels can
> grok.

Sure, but my suggestion is just a way to make it possible without having
to maintain a lot of duplicated code. The point is simply that we'll be
getting rid of nopage from mainline sooner or later, and it will probably
be less painful for your out of tree stuff if you do it rather than me. Maybe.


> It isn't pretty but it works.

It is pretty for mainline :) I appreciate you going out of your way to make
the code nicer rather than just make your life easier.
