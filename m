Return-Path: <linux-kernel-owner+w=401wt.eu-S1765713AbYCDSUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765713AbYCDSUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760756AbYCDSUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:20:08 -0500
Received: from c-67-188-67-135.hsd1.ca.comcast.net ([67.188.67.135]:42786 "EHLO
	freya" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758542AbYCDSUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:20:07 -0500
Date: Tue, 4 Mar 2008 10:19:31 -0800
From: "Adam J. Richter" <adam@yggdrasil.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Patch: romfs_lookup always failed in linux-2.6.25-rc3-git3
Message-ID: <20080304181931.GA24301@freya.fugue.com>
References: <20080303173620.GA9243@freya.fugue.com> <20080304012621.b84fc769.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304012621.b84fc769.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 01:26:21AM -0800, Andrew Morton wrote:
> On Mon, 3 Mar 2008 09:36:20 -0800 "Adam J. Richter" <adam@yggdrasil.com> wrote:
[...]
> > P.S. romfs_lookup casts a valid pointer to an int and then back again
> > with res = PTR_ERR(inode);...return ERR_PTR(res).  This may break on
> > arhictectures where sizeof(int) < sizeof(pointer).  If I want to submit
> > a subsequent fix for this, are you the person I should the patch to?

	Oops, please ignore my incorrect "P.S.".  As David Howells has
explained, the PTR_ERR(inode) call is only done when inode is known to
contain an error code, so it should be safe on all architectures.

	Sorry for the false alarm about that part.

Adam
