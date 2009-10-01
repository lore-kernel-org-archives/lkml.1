Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbZJAK3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbZJAK3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 06:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbZJAK25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 06:28:57 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:50129 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171AbZJAK2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 06:28:54 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic guest and host communication
Date: Thu, 1 Oct 2009 12:28:30 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-prerelease; KDE/4.3.1; i686; ; )
Cc: Rusty Russell <rusty@rustcorp.com.au>, Alan Cox <alan@linux.intel.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <200909291531.23389.borntraeger@de.ibm.com> <20090930171321.GA17200@amit-x200.redhat.com>
In-Reply-To: <20090930171321.GA17200@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910011228.30563.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 30 September 2009 19:13:21 schrieben Sie:
> On (Tue) Sep 29 2009 [15:31:23], Christian Borntraeger wrote:
> > Am Dienstag 29 September 2009 15:09:50 schrieb Amit Shah:
> > > Great, thanks. However I was thinking of moving this init to the
> > > probe() routine instead of in the init_conosle routine just because
> > > multiple consoles can be added and we don't want to init this each
> > > time.. just once in probe is fine.
> >
> > If you have new patch CC me and I can give it a spin.
> 
> Hey Christian,
> 
> I have a new patch that changes a few things:
> - moves the put_char fix to probe instead of doing it in
>   init_port_console(), which gets called on each console port found.
> - uses port->id instead of a static hvc_vtermno to pass on a value to
>   hvc_alloc(). Motivation explained within comments in the code.
> - A few other changes that introduce and make use of port->vcon instead
>   of accessing the static virtconsole directly -- aimed at easing future
>   fix to have multiple virtio-console devices.
> 
> It would be great if you could test this.

With the latest git kernel + your patch I sometmes get a completely frozen 
console. In the dump there is 

    <3>virtio_console virtio0: output:id 68 is not a head!

Seems that I can reproduce it with large amounts of output (find / for example)
Without your patch everything is fine.

Christian

