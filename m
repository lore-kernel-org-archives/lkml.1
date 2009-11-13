Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbZKMKl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbZKMKl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbZKMKlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:41:51 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60332 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755683AbZKMKlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:41:51 -0500
Date: Fri, 13 Nov 2009 10:43:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg Steuck <greg@nest.cx>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RT wakeup woes in Linux 2.6.31.6 on Mac Mini
Message-ID: <20091113104338.503e53d4@lxorguk.ukuu.org.uk>
In-Reply-To: <a27c0c970911121552w63f63baew93d06336b39816a5@mail.gmail.com>
References: <a27c0c970911121552w63f63baew93d06336b39816a5@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> trace.13653:kblockd/-65      1dN..  132us+: blk_rq_map_sg <-scsi_init_sgtable
> trace.13653:kblockd/-65      1dN..  200us+: blk_rq_map_sg <-scsi_init_sgtable
> trace.13653:kblockd/-65      1dN..  264us+: ata_tf_to_fis <-ahci_qc_prep
> trace.13653:kblockd/-65      1dN..  289us+: blk_rq_map_sg <-scsi_init_sgtable
> trace.13653:kblockd/-65      1dN..  349us+: ata_tf_to_fis <-ahci_qc_prep

Something very weird with your tracing there ata_tf_to_fis simply moves
20 bytes of memory about. It could be you are hitting some kind of
caching effect with the AHCI controller I guess. Certainly looks odd of
itself.

> ...
> trace.6039: pdflush-5162    1d.s.    0us :   5162:120:R   + [001]
> 6040:  0:S rxtest
> trace.6039: pdflush-5162    1dN..   61us+: idle_cpu <-irq_exit
> trace.6039: pdflush-5162    1dN..  130us!: idle_cpu <-irq_exit
> trace.6039: pdflush-5162    1dN..  273us!: idle_cpu <-irq_exit

What power management do you have enabled ?
