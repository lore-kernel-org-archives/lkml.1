Return-Path: <linux-kernel-owner+w=401wt.eu-S1758409AbYAPIfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409AbYAPIfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 03:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbYAPIfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 03:35:36 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57467 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbYAPIff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 03:35:35 -0500
Date: Wed, 16 Jan 2008 10:35:32 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Christoph Hellwig <hch@infradead.org>
cc: Peter Zijlstra <peterz@infradead.org>, alan@redhat.com,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC/PATCH 4/8] revoke: core code V7
In-Reply-To: <20080115172741.GA20388@infradead.org>
Message-ID: <Pine.LNX.4.64.0801161029160.27552@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0712141716370.28689@sbz-30.cs.Helsinki.FI>
 <1200410094.26045.29.camel@twins> <20080115172741.GA20388@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 15 Jan 2008, Christoph Hellwig wrote:
> Something like the loop above is not going to go in for sure.  Once we
> get rid of the sb->s_files we can put the list_head in struct file to
> new use eventually if we don't want to get rid of it.  E.g. and
> per-inode list would be much better than the per-superblock one and
> would regularize what the tty driver is doing.

Sure, adding a list of struct files to struct inode obviously works for 
me. But it does increase the size of struct inode which I thought you're 
not allowed to do ;-)

Anyway, there are still some other problems with this patch if we want to 
use it to implement forced unmount (my bad, we can't go changing struct 
inode because it's shared by different mount points).

			Pekka
