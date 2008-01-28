Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbYA1IT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbYA1IT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYA1ITU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:19:20 -0500
Received: from ns2.suse.de ([195.135.220.15]:43272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbYA1ITU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:19:20 -0500
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [8/18] BKL-removal: Remove BKL from remote_llseek
Date: Mon, 28 Jan 2008 09:17:52 +0100
User-Agent: KMail/1.9.1
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Steve French <smfrench@gmail.com>, swhiteho@redhat.com,
       sfrench@samba.org, vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <20080127317.043953000@suse.de> <200801280538.25345.ak@suse.de> <20080127211345.6e73fa0b.akpm@linux-foundation.org>
In-Reply-To: <20080127211345.6e73fa0b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801280917.52574.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I completely agree.  If one thread writes A and another writes B then the
> kernel should record either A or B, not ((A & 0xffffffff00000000) | (B &
> 0xffffffff))

The problem is pretty nasty unfortunately. To solve it properly I think
the file_operations->read/write prototypes would need to be changed
because otherwise it is not possible to do atomic relative updates
of f_pos. Right now the actual update is burrowed deeply in the low level 
read/write implementation. But that would be a huge impact all over
the tree :/

Or maybe define a new read/write64 and keep the default as 32bit only-- i 
suppose most users don't really need 64bit. Still would be a nasty API 
change.

-Andi
