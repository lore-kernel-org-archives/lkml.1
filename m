Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYLVVYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYLVVYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbYLVVYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:24:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60485 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbYLVVYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:24:37 -0500
Date: Mon, 22 Dec 2008 21:24:33 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Sandeep K Sinha <sandeepksinha@gmail.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] Re: Device mapper support for more than one target ?
Message-ID: <20081222212433.GA17247@agk.fab.redhat.com>
Mail-Followup-To: Sandeep K Sinha <sandeepksinha@gmail.com>,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com
References: <37d33d830812220922l5a0bc36et5dd1f9853f9cd33@mail.gmail.com> <20081222185033.GA17119@agk.fab.redhat.com> <37d33d830812221054w78fe49f3l6c2896a27c908656@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37d33d830812221054w78fe49f3l6c2896a27c908656@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 12:24:49AM +0530, Sandeep K Sinha wrote:
> On Tue, Dec 23, 2008 at 12:20 AM, Alasdair G Kergon <agk@redhat.com> wrote:
> > On Mon, Dec 22, 2008 at 10:52:08PM +0530, Sandeep K Sinha wrote:
> > Because whether or not it makes sense to send any specific ioctl to more
> > than one target in parallel depends on what that ioctl does.  When we
> > added that code we said that we could add hard-coding for specific
> > ioctls if the need arose, but so far it hasn't.
> No, the philosophy should be that we send the ioctl's to the mapped
> device and not to the targets underlying that mapped-device.

That's not what the current implementation was for, viz. passing scsi
ioctls through dm multipath devices.

> And doing so, I should be able to access the complete map that belongs
> to that mapped device. If I implement an ioctl of my own and try to
> serve it, the problem would be that it would never allow me to serve
> it if has more than one target.

As I said above, if the need arises we can have a whitelist mechanism
for ioctls to be handled differently, but the only safe default
behaviour is the one that has been implemented.

Alasdair
-- 
agk@redhat.com
