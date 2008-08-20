Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYHTWMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYHTWMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 18:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYHTWL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 18:11:59 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36898 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbYHTWL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 18:11:58 -0400
Subject: Re: checkpoint/restart ABI
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Theodore Tso <tytso@mit.edu>,
       Daniel Lezcano <daniel.lezcano@fr.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Peter Chubb <peterc@gelato.unsw.edu.au>
In-Reply-To: <48AC929C.9030901@cs.columbia.edu>
References: <20080807224033.FFB3A2C1@kernel>
	 <200808090013.41999.arnd@arndb.de> <20080811152201.GB25930@us.ibm.com>
	 <200808111853.13854.arnd@arndb.de> <1218484114.5598.43.camel@nimitz>
	 <48A0CD86.6030704@goop.org> <1218553091.5598.76.camel@nimitz>
	 <48A1BB39.3090108@goop.org> <1218559619.5598.97.camel@nimitz>
	 <48AC929C.9030901@cs.columbia.edu>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 15:11:54 -0700
Message-Id: <1219270314.8960.74.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-20 at 17:54 -0400, Oren Laadan wrote:
> > Me, personally, I think I'd probably "re-link" the thing, mark it as
> > such, ship it across like a normal file, then unlink it after the
> > restore.  I don't know what we'd choose when actually implementing
> it.  
> 
> Re-linking works well when the file system supports that - some do not
> allow this, in which case you need to silently rename instead of really
> un-linking (even with NFS), or copy the entire contents.

Yeah, it will certainly be fs-dependent.

This might be a good application for splice.

	open("/tmp/linked-newfile", O_RDONLY, perms);
	splice(unlinked_fd, NULL, new_fd, NULL, MAX_INT, SPLICE_F_MOVE);

I'm not sure if it can re-use the blocks on the fs for this, but it
probably doesn't matter.  

-- Dave

