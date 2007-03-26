Return-Path: <linux-kernel-owner+w=401wt.eu-S1751581AbXCZLag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbXCZLag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 07:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbXCZLag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 07:30:36 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41074 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbXCZLaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 07:30:35 -0400
Date: Mon, 26 Mar 2007 14:30:34 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: David Howells <dhowells@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH -mm] Revoke core code: fix nommu arch compiling error
 bug
In-Reply-To: <6017.1174908318@redhat.com>
Message-ID: <Pine.LNX.4.64.0703261427490.12793@sbz-30.cs.Helsinki.FI>
References: <20070326024143.a226c9b2.akpm@linux-foundation.org> 
 <1174904637.32691.86.camel@roc-desktop>  <6017.1174908318@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, 26 Mar 2007, David Howells wrote:
> The reason is that, at the moment, VMAs are a global *shared* resource in
> NOMMU-mode.  Each process has a list of global VMAs that it subscribes to, but
> that's it.  This (a) slightly reduces the amount of metadata allocated
> (possibly), and (b) makes sharing of executables and libraries much easier.

On Mon, 26 Mar 2007, David Howells wrote:
> I wonder if revoke_mm() is something that you can't do in NOMMU-mode.  What
> does it do?

The revoke_mm() function scans all vmas of a mm and revokes those that 
are shared and point to the inode being revoked. So, NOMMU can't do that.

But what's more important is, can we do revoke_mapping() for NOMMU? AFAICT 
we can, we just need to scan all the global vmas, right?

				Pekka
