Return-Path: <linux-kernel-owner+w=401wt.eu-S1760687AbYA1NDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687AbYA1NDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 08:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbYA1NC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 08:02:58 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58826 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750967AbYA1NC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 08:02:57 -0500
Date: Mon, 28 Jan 2008 12:56:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Trond Myklebust <Trond.Myklebust@netapp.com>,
       Steve French <smfrench@gmail.com>, swhiteho@redhat.com,
       sfrench@samba.org, vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] [8/18] BKL-removal: Remove BKL from remote_llseek
Message-ID: <20080128125605.299740a1@core>
In-Reply-To: <20080127211345.6e73fa0b.akpm@linux-foundation.org>
References: <20080127317.043953000@suse.de>
	<200801280358.14024.ak@suse.de>
	<1201493589.8132.7.camel@heimdal.trondhjem.org>
	<200801280538.25345.ak@suse.de>
	<20080127211345.6e73fa0b.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > No specific spec, just general quality of implementation.
> 
> I completely agree.  If one thread writes A and another writes B then the
> kernel should record either A or B, not ((A & 0xffffffff00000000) | (B &
> 0xffffffff))

Agree entirely: the spec doesn't allow for random scribbling in the wrong
place. It doesn't cover which goes first or who "wins" the race but
provides pwrite/pread for that situation. Writing somewhere unrelated is
definitely not to spec and not good.
