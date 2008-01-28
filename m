Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbYA1SeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbYA1SeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbYA1Sdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:33:46 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:59803 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbYA1Sdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:33:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KK3W56PDdgijV21RBIYt5THMRUQ07/iCr+nTeem17LKVvzIGLGmHiCy6Q/ZLqHhFrREYD87v7wBljb4wYmCbMnL2g7J4Y1HaMvavqWR4N5T/822U846fz1E4+4VGLyjcxyMB8Lao4GVIRGkpAQr4YEIXurDl7Noht+zVamQnybg=
Message-ID: <524f69650801281033o542e18c5y696dc239b70f1307@mail.gmail.com>
Date: Mon, 28 Jan 2008 12:33:42 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] [8/18] BKL-removal: Remove BKL from remote_llseek
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Trond Myklebust" <Trond.Myklebust@netapp.com>, swhiteho@redhat.com,
       sfrench@samba.org, vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <200801280917.52574.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080127317.043953000@suse.de> <200801280538.25345.ak@suse.de>
	 <20080127211345.6e73fa0b.akpm@linux-foundation.org>
	 <200801280917.52574.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 28, 2008 2:17 AM, Andi Kleen <ak@suse.de> wrote:
> > I completely agree.  If one thread writes A and another writes B then the
> > kernel should record either A or B, not ((A & 0xffffffff00000000) | (B &
> > 0xffffffff))
>
> The problem is pretty nasty unfortunately. To solve it properly I think
> the file_operations->read/write prototypes would need to be changed
> because otherwise it is not possible to do atomic relative updates
> of f_pos. Right now the actual update is burrowed deeply in the low level
> read/write implementation. But that would be a huge impact all over
> the tree :/

If there were a wrapper around reads and writes of f_pos as there is
for i_size e.g. it would hit a lot of code, but not as many as I had
originally thought.  the most important ones are in the vfs itself, where
there are only 59 uses of the field (not all need to be changed).   ext3
has fewer (25), and cifs only 12 uses.


-- 
Thanks,

Steve
