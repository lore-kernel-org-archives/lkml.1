Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbYLSISz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbYLSISz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 03:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbYLSISq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 03:18:46 -0500
Received: from ns1.suse.de ([195.135.220.2]:32879 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbYLSISo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 03:18:44 -0500
Date: Fri, 19 Dec 2008 09:18:41 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Seewer Philippe <philippe.seewer@bfh.ch>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>,
       <initramfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>,
       <cjwatson@ubuntu.com>, Bernhard Walle <bwalle@novell.com>
Subject: Re: Dracut -- Cross distribution initramfs infrastructure
Message-ID: <20081219091841.207bc951@kopernikus.site>
In-Reply-To: <494B5031.5080306@bfh.ch>
References: <1229540094.28858.150.camel@aglarond.local>
	<20081217190700.GA15377@infradead.org>
	<4949FD67.6040906@suse.de>
	<494B5031.5080306@bfh.ch>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Seewer Philippe [2008-12-19 08:41]:
>
> Hannes Reinecke wrote:
> [snip]
> > If anyone is interested I can give a short overview of it.
> Please do so, would be appreciated.

A good start is the manual page in section 5:
http://git.opensuse.org/?p=projects/mkinitrd.git;a=blob_plain;f=man/mkinitrd.5.txt;hb=7583c3cc047edc3e8f1a06e8b7925bd27ac0228c

(The git.kernel.org and the opensuse.org repos are basically the same,
we just switched to opensuse.org after the internal maintainership has
been transferred from Hannes to myself because it was easier to add
new users there. The opensuse.org git repo site didn't exist when the
kernel.org mkinitrd repo was created.)

Anyway:

The basic idea is to have most stuff not in the main 'mkinitrd' script
but in modules. Each module has (normally) a setup script part that is
executed when the initrd is created, and a boot part that is executed
when the initrd is running. For example, NFS root is in the 'nfs-util'
package, not in 'mkinitrd'. Same for iSCSI. Or the kdump part is
not in the main mkinitrd but in our 'kdump' package [1]. So the main
initrd  package is quite small but still very flexible.

It's also flexible enough to use Busybox as module that resides in the
'busybox' package and can then be enabled with -F busybox (feature)
when building the initrd.

Only documentation is at the current time a bit weak, one has to fiddle
some stuff from the sources when writing new modules. But that's easy
to fix. :-)

Hannes may explain more ...



    Bernhard

[1] hg clone http://freehg.org/u/bwalle/kdump/
