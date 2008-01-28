Return-Path: <linux-kernel-owner+w=401wt.eu-S1759670AbYA1TfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670AbYA1TfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbYA1Tez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:34:55 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48637 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbYA1Tey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:34:54 -0500
Subject: Re: [PATCH] [8/18] BKL-removal: Remove BKL from remote_llseek
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Steve French <smfrench@gmail.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>, swhiteho@redhat.com,
       sfrench@samba.org, vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <524f69650801281033o542e18c5y696dc239b70f1307@mail.gmail.com>
References: <20080127317.043953000@suse.de> <200801280538.25345.ak@suse.de>
	 <20080127211345.6e73fa0b.akpm@linux-foundation.org>
	 <200801280917.52574.ak@suse.de>
	 <524f69650801281033o542e18c5y696dc239b70f1307@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 19:34:39 +0000
Message-Id: <1201548879.6784.13.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-28 at 12:33 -0600, Steve French wrote:
> On Jan 28, 2008 2:17 AM, Andi Kleen <ak@suse.de> wrote:
> > > I completely agree.  If one thread writes A and another writes B then the
> > > kernel should record either A or B, not ((A & 0xffffffff00000000) | (B &
> > > 0xffffffff))
> >
> > The problem is pretty nasty unfortunately. To solve it properly I think
> > the file_operations->read/write prototypes would need to be changed
> > because otherwise it is not possible to do atomic relative updates
> > of f_pos. Right now the actual update is burrowed deeply in the low level
> > read/write implementation. But that would be a huge impact all over
> > the tree :/
> 
> If there were a wrapper around reads and writes of f_pos as there is
> for i_size e.g. it would hit a lot of code, but not as many as I had
> originally thought.  the most important ones are in the vfs itself, where
> there are only 59 uses of the field (not all need to be changed).   ext3
> has fewer (25), and cifs only 12 uses.

Most of the uses in ext3 and cifs deal with a directory's f_pos in
readdir, which is protected by i_mutex, so I don't think we need to
worry about them at all.
-- 
David Kleikamp
IBM Linux Technology Center

