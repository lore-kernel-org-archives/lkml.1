Return-Path: <linux-kernel-owner+w=401wt.eu-S1760424AbYA1N1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760424AbYA1N1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 08:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbYA1N1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 08:27:41 -0500
Received: from mail.suse.de ([195.135.220.2]:48343 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbYA1N1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 08:27:40 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] [8/18] BKL-removal: Remove BKL from remote_llseek
Date: Mon, 28 Jan 2008 14:27:35 +0100
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Steve French <smfrench@gmail.com>, swhiteho@redhat.com,
       sfrench@samba.org, vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <20080127317.043953000@suse.de> <20080127211345.6e73fa0b.akpm@linux-foundation.org> <20080128125605.299740a1@core>
In-Reply-To: <20080128125605.299740a1@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281427.36048.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008 13:56:05 Alan Cox wrote:
> > > No specific spec, just general quality of implementation.
> > 
> > I completely agree.  If one thread writes A and another writes B then the
> > kernel should record either A or B, not ((A & 0xffffffff00000000) | (B &
> > 0xffffffff))
> 
> Agree entirely: the spec doesn't allow for random scribbling in the wrong
> place. It doesn't cover which goes first or who "wins" the race but
> provides pwrite/pread for that situation. Writing somewhere unrelated is
> definitely not to spec 

Actually it would probably -- i guess it's undefined and in undefined
country such things can happen.

Also to be fair I think it's only a problem for the 4GB wrapping case
which is presumably rare (otherwise we would have heard about it)

Also worse really fixing it would be a major change to the VFS 
because of the way ->read/write are defined :/

-Andi
