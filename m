Return-Path: <linux-kernel-owner+w=401wt.eu-S1759383AbYBWHm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbYBWHm5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 02:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbYBWHmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 02:42:49 -0500
Received: from mail.gmx.net ([213.165.64.20]:52846 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754667AbYBWHms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 02:42:48 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19gEA8RmAxgjF7p1fz8A1NNg3Ic3905U/Cjn8qIEv
	r4L05TmqTcQ1ED
Subject: Re: regression: CD burning (k3b) went broke
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>
In-Reply-To: <20080222073228.GZ23197@kernel.dk>
References: <1203583379.6244.27.camel@homer.simson.net>
	 <20080222073228.GZ23197@kernel.dk>
Content-Type: text/plain
Date: Sat, 23 Feb 2008 08:42:43 +0100
Message-Id: <1203752563.5225.4.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-22 at 08:32 +0100, Jens Axboe wrote: 
> On Thu, Feb 21 2008, Mike Galbraith wrote:
> > Greetings,
> > 
> > K3b recently (9a4c854..5d9c4a7 pull) began terminally griping about
> > buffer underrun upon every attempt to burn a CD.  I can't fully bisect
> > the problem  because intervening kernels hang soft during boot.  Using
> > git bisect visualize, and converting to postable text:
> > 
> > bisect/bad   block: add request->raw_data_len (6b00769fe1502b4ad97bb327ef7ac971b208bfb5)
> > bisect           block: update bio according to DMA alignment padding (40b01b9bbdf51ae543a04744283bf2d56c4a6afa)
> > libata: update ATAPI overflow draining
> > bisect/good-e164094964e6e20fe7fce418e06a9dce952bb7a4
> 
> Tejun?

<crickets chirping>  He must be off having a life or something ;-)

 Meanwhile back at the ranch, reverting
6b00769fe1502b4ad97bb327ef7ac971b208bfb5
40b01b9bbdf51ae543a04744283bf2d56c4a6afa and the one entangled line from
dde2020754aeb14e17052d61784dcb37f252aac2 did restore my burner.

	-Mike



