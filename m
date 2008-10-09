Return-Path: <linux-kernel-owner+w=401wt.eu-S1757424AbYJICi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbYJICi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 22:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbYJICir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 22:38:47 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:46844 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753783AbYJICiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 22:38:46 -0400
Date: Wed, 8 Oct 2008 22:38:37 -0400
From: Theodore Tso <tytso@mit.edu>
To: Quentin Godfroy <godfroy@clipper.ens.fr>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: possible (ext4 related?) memory leak in kernel 2.6.26
Message-ID: <20081009023837.GC17512@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Quentin Godfroy <godfroy@clipper.ens.fr>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20081005091526.GA678@goelette.ens.fr> <20081005122752.GB27335@mit.edu> <20081005161214.GA2985@goelette.ens.fr> <20081006025006.GA9289@mit.edu> <48EA2F20.7020309@redhat.com> <20081006175502.GA12937@mit.edu> <20081007221256.GF15929@mit.edu> <20081008000227.GA32052@goelette.ens.fr> <20081008005338.GH15929@mit.edu> <200810082355.m98NtZkQ012577@goelette.ens.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810082355.m98NtZkQ012577@goelette.ens.fr>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 01:52:46AM +0200, Quentin Godfroy wrote:
> 
> Indeed after a couple of days of uptime the number of dirty blocks do not go
> further than ~50, so I think the bug is corrected as far as I am concerned.
> 
> By the way, why does the kernel not commit to memory these remaining buffers
> when the memory is scarse (say instead of firing an OOM killer)?

The bug was the jbd2 code was bumping the reference count for the
buffers, so they were considered "in-use" and thus couldn't be freed
and released for other uses.

Regards,

						- Ted
