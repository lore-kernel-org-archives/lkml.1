Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbYA1Eik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbYA1Eik (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 23:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYA1Eia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 23:38:30 -0500
Received: from ns2.suse.de ([195.135.220.15]:56413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbYA1Ei3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 23:38:29 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH] [8/18] BKL-removal: Remove BKL from remote_llseek
Date: Mon, 28 Jan 2008 05:38:25 +0100
User-Agent: KMail/1.9.6
Cc: Steve French <smfrench@gmail.com>, swhiteho@redhat.com, sfrench@samba.org,
       vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
References: <20080127317.043953000@suse.de> <200801280358.14024.ak@suse.de> <1201493589.8132.7.camel@heimdal.trondhjem.org>
In-Reply-To: <1201493589.8132.7.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801280538.25345.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008 05:13:09 Trond Myklebust wrote:
> 
> On Mon, 2008-01-28 at 03:58 +0100, Andi Kleen wrote:
> > The problem is that it's not a race in who gets to do its thing first, but a 
> > parallel reader can actually see a corrupted value from the two independent 
> > words on 32bit (e.g. during a 4GB). And this could actually completely corrupt 
> > f_pos when it happens with two racing relative seeks or read/write()s
> > 
> > I would consider that a bug.
> 
> I disagree. The corruption occurs because this isn't a situation that is
> allowed by either POSIX or SUSv2/v3. Exactly what spec are you referring
> to here?

No specific spec, just general quality of implementation. We normally don't have
non thread safe system calls even if it was in theory allowed by some specification.

-Andi
