Return-Path: <linux-kernel-owner+w=401wt.eu-S1756258AbZJAKn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbZJAKn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 06:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbZJAKn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 06:43:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535AbZJAKn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 06:43:56 -0400
Date: Thu, 1 Oct 2009 16:12:49 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
	generic guest and host communication
Message-ID: <20091001104249.GA12439@amit-x200.redhat.com>
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <200909291531.23389.borntraeger@de.ibm.com> <20090930171321.GA17200@amit-x200.redhat.com> <200910011228.30563.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910011228.30563.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) Oct 01 2009 [12:28:30], Christian Borntraeger wrote:
> Am Mittwoch 30 September 2009 19:13:21 schrieben Sie:
> > On (Tue) Sep 29 2009 [15:31:23], Christian Borntraeger wrote:
> > > Am Dienstag 29 September 2009 15:09:50 schrieb Amit Shah:
> > > > Great, thanks. However I was thinking of moving this init to the
> > > > probe() routine instead of in the init_conosle routine just because
> > > > multiple consoles can be added and we don't want to init this each
> > > > time.. just once in probe is fine.
> > >
> > > If you have new patch CC me and I can give it a spin.
> > 
> > Hey Christian,
> > 
> > I have a new patch that changes a few things:
> > - moves the put_char fix to probe instead of doing it in
> >   init_port_console(), which gets called on each console port found.
> > - uses port->id instead of a static hvc_vtermno to pass on a value to
> >   hvc_alloc(). Motivation explained within comments in the code.
> > - A few other changes that introduce and make use of port->vcon instead
> >   of accessing the static virtconsole directly -- aimed at easing future
> >   fix to have multiple virtio-console devices.
> > 
> > It would be great if you could test this.
> 
> With the latest git kernel + your patch I sometmes get a completely frozen 
> console. In the dump there is 
> 
>     <3>virtio_console virtio0: output:id 68 is not a head!
> 
> Seems that I can reproduce it with large amounts of output (find / for example)
> Without your patch everything is fine.

Do you mean the entire patch? Or just the last snippet that I sent?

I'm testing things using a few days old linux-next; I guess you're
seeing this with Linus' git tree?

I'll try that.

		Amit
