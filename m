Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab0BBSsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 13:48:36 -0500
Received: from alt.dspnet.fr.eu.org ([213.186.44.138]:1429 "EHLO
	dspnet.fr.eu.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756799Ab0BBSsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 13:48:33 -0500
Date: Tue, 2 Feb 2010 19:48:31 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/11] readahead: dont do start-of-file readahead after lseek()
Message-ID: <20100202184831.GD75577@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20100202152835.683907822@intel.com> <20100202153317.644170708@intel.com> <20100202181321.GB75577@dspnet.fr.eu.org> <alpine.LFD.2.00.1002021037110.3664@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002021037110.3664@localhost.localdomain>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 10:40:41AM -0800, Linus Torvalds wrote:
> IOW, if you start off with a SEEK_END, I think it's reasonable to expect 
> it to _not_ read the whole thing.

I've seen a lot of:
  int fd = open(...);
  size = lseek(fd, 0, SEEK_END);
  lseek(fd, 0, SEEK_SET);

  data = malloc(size);
  read(fd, data, size);
  close(fd);

Why not fstat?  I don't know.  Perhaps a case of cargo culting,
perhaps a case of "other unixes suck for portability"[1].  But it's
probably still there a lot in real code.

  OG.

[1] In the hpux, dgux, sunos, etc sense.  Not to be taken as a comment
    on modern BSDs.
