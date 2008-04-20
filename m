Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbYDTKTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbYDTKTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbYDTKTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:19:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:14166 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbYDTKTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:19:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=EnHn509EhKR10ivrkeKvdCasvOzF4Wb3UdwevKfWlmvbATKcv9jaDr4wBhWmcYZ034uwBfWQSnPmFCiI85yol2qeREBFbclxveYIX6J88kp32KAvdDYE2m4RwUDpZ0U0H+7StZP05CNIAoF8scC/sXOCv8nVJJ/c7DC/xD8dfQM=
Date: Sun, 20 Apr 2008 15:14:53 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jay Cliburn <jacliburn@bellsouth.net>
Cc: Luca Tettamanti <kronos.it@gmail.com>, Chris Snook <csnook@redhat.com>,
       Jeff Garzik <jeff@garzik.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       torvalds@osdl.org
Subject: Re: atl1 64-bit => 32-bit DMA borkage (reproducible, bisected)
Message-ID: <20080420111453.GA4902@martell.zuzino.mipt.ru>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org> <20080413204422.GA5136@martell.zuzino.mipt.ru> <84144f020804140901p1c076fd2q73e3effe7cd96da3@mail.gmail.com> <Pine.LNX.4.64.0804141050550.6296@schroedinger.engr.sgi.com> <20080414183221.GA5234@martell.zuzino.mipt.ru> <20080414195613.GA4772@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0804141301580.7803@schroedinger.engr.sgi.com> <20080419111719.GA6724@martell.zuzino.mipt.ru> <20080419144535.GA4814@martell.zuzino.mipt.ru> <20080419215444.2d4623f5@osprey.hogchain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080419215444.2d4623f5@osprey.hogchain.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2008 at 09:54:44PM -0500, Jay Cliburn wrote:
> On Sat, 19 Apr 2008 18:45:35 +0400
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > OK, nailed it.
> > 
> > It's commit 5f08e46b621a769e52a9545a23ab1d5fb2aec1d4 aka "atl1:
> > disable broken 64-bit DMA".
> > 
> > With this commit in tree, I can reproduce either
> > a) kmalloc-2048 corruption after initscripts shutdown eth0
> > 	http://marc.info/?l=linux-kernel&m=120820360221261&w=2
> > 
> > b) or oopses at filp_close() first reported long ago
> > 	(sorry, can't find that email)
> > 
> > c) or hard hang after initscripts shutdown eth0 with even SysRq not
> > working. http://marc.info/?l=linux-kernel&m=120795046008115&w=2
> > 
> > I have two boxes one with atl1, 4G RAM with 2G remapped after 4G
> > boundary, another with r8169 connected with just ethernet cable. NICs
> > agree on 1Gbps speed.
> > 
> > So, it's enough to scp 200 MB git archive and immediately start
> > rebooting sequence for horrors described above to appear. It's not
> > 100% reproducible but more like 90%.
> 
> Do I understand correctly that these failures occur only while the
> network interface is going down?

Yep. During up or running there were no problems with this card.

