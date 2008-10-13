Return-Path: <linux-kernel-owner+w=401wt.eu-S1759753AbYJMSN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759753AbYJMSN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757739AbYJMSNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:13:46 -0400
Received: from lazybastard.de ([212.112.238.170]:51310 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757556AbYJMSNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:13:45 -0400
Date: Mon, 13 Oct 2008 20:13:33 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Chris Snook <csnook@redhat.com>
Cc: Stefan Monnier <monnier@iro.umontreal.ca>, linux-kernel@vger.kernel.org
Subject: Re: Filesystem for block devices using flash storage?
Message-ID: <20081013181333.GB22447@logfs.org>
References: <jwvvdw33v5p.fsf-monnier+gmane.linux.kernel@gnu.org> <48ED1D62.8080100@redhat.com> <20081012143505.GA15799@logfs.org> <48F385B5.1040503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48F385B5.1040503@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 October 2008 13:30:29 -0400, Chris Snook wrote:
> >
> >>logfs tries to solve the write amplification problem by forcing all write 
> >>activity to be sequential.  I'm not sure how mature it is.
> >
> >Still under development.  What exactly do you mean by the write
> >amplification problem?
> 
> Write amplification is where a 512 byte write turns into a 128k write, 
> due to erase block size.

Ah, yes.  Current logfs still triggers that a bit too often.  I'm
currently working on the format changes to avoid the amplification as
much as possible.

Another nasty side effect of this is that heuristics for wear leveling
are always imprecise.  And wear leveling is still required for most
devices.  See http://www.linuxconf.eu/2007/papers/Engel.pdf

> Intel is claiming a write amplification factor of 1.1.  Either they're 
> using very small erase blocks, or doing something very smart in the 
> controller.

With very small erase blocks the facter should be either 1 or 2, not
1.1.  Most likely they work very much like logfs does, essentially doing
the whole log-structured thing internally.

Jörn

-- 
Das Aufregende am Schreiben ist es, eine Ordnung zu schaffen, wo
vorher keine existiert hat.
-- Doris Lessing
