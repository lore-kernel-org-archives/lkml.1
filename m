Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbXJ3Uma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbXJ3Uma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbXJ3UmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:42:22 -0400
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:40713 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752777AbXJ3UmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:42:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=INaFlErqWQGKiEBt+ZmwaDoa1Zo6F/wwnv+n00pLhpj5wWfH3aVTXXFsx+8tsNN+FvKcd+R6hiUPULb9vY9hUCIQ5PDN5tMn6uSIhJaTWwIDZEn9Cp2jdo9lclz+Zz9mDsMP6TbZGLEwWetR7e8PYNjXQtYf7Lapa/9NoVDBAbw=  ;
X-YMail-OSG: m6PnUL0VM1lXpW0yKosKjiWWJroggkLIviIYzFs0GY4Ddj7SyhPLjqNIJ.md5Nu50fBqPvQDRw--
From: David Brownell <david-b@pacbell.net>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH 00/14] Blackfin on-chip SPI controller driver updates and bug-fixing
Date: Tue, 30 Oct 2007 13:42:18 -0700
User-Agent: KMail/1.9.6
Cc: "Bryan Wu" <bryan.wu@analog.com>, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com> <200710301324.07691.david-b@pacbell.net> <8bd0f97a0710301329i8a21b22ncc9f71a81bc06543@mail.gmail.com>
In-Reply-To: <8bd0f97a0710301329i8a21b22ncc9f71a81bc06543@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710301342.18559.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 October 2007, Mike Frysinger wrote:
> On 10/30/07, David Brownell <david-b@pacbell.net> wrote:
> > And also, pay closer attention to when you may be making
> > changes that make device drivers work differently over
> > your spi_master controller driver than anyone elses ...
> > such platform-specific behaviors are undesirable, and when
> > they go against specified behavior they are also bugs.
> 
> was there something that caught your eye other than the ugly udelay()
> you mentioned in the other thread ?

That one was a feature that might be more generally necessary,
just to meet chip timing specs.  Mostly they're no trouble.
But sometimes there are constraints around chipselect, or at
particular points in a protocol exchange ... as you know, SPI
has no in-band synchronization, so timing delays are about as
good as any standardized infrastructure can get.  So if that
particular timing tweak was essential to make that driver work,
it might be something the API should address -- instead of just
a particular controller.

The other point was the handling of the two spi_transfer protocol
tweaking options.  The comment went against the interface spec.
Now, maybe that was an issue of weak English skills ... but from
my scanning the patch, I got the impression one intent of that
patch really was to do what the comment said.  (Of course it did
a lot of other stuff, which looked less dubious and might have
had a lot more to do with why the patch made that m25p16 chip
behave on that new board.)

- Dave
