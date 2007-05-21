Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbXEUMhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbXEUMhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 08:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbXEUMhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 08:37:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788AbXEUMhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 08:37:42 -0400
Date: Mon, 21 May 2007 08:37:38 -0400
From: Alan Cox <alan@redhat.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Robert de Rooy <robert.de.rooy@gmail.com>, linux-kernel@vger.kernel.org,
       alan@redhat.com, bzolnier@gmail.com, jgarzik@pobox.com
Subject: Re: libata and legacy ide pcmcia failure
Message-ID: <20070521123738.GA30639@devserv.devel.redhat.com>
References: <464A0321.3080201@gmail.com> <464C1575.8070005@gmail.com> <464CB7C9.2080807@gmail.com> <46503192.1040300@gmail.com> <4650B9E3.7070409@gmail.com> <46518798.2020808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46518798.2020808@gmail.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 01:50:48PM +0200, Tejun Heo wrote:
> > May 20 23:02:56 localhost kernel: ata3.00: qc timeout (cmd 0xef)
> > May 20 23:02:56 localhost kernel: ata3.00: failed to set xfermode
> > (err_mask=0x4)
> 
> Hmmm... It doesn't like SETXFERMASK either.  Please try the attached patch.

The CF 1.1 command list is pretty short. Unfortunately the patch you've
given below won't itself cure the problem as some of the newer CF cards do
need SETXFERMASK issuing to do higher PIO modes.

The CFA people also didn't put the CFA version in the ident data. What might
work sanely would be

	if (supports_pio == only_pio0 && cfa)

Alan

