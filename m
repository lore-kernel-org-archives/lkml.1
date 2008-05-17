Return-Path: <linux-kernel-owner+w=401wt.eu-S1760697AbYEQAgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbYEQAgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 20:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbYEQAf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 20:35:58 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2364 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753072AbYEQAf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 20:35:57 -0400
Date: Fri, 16 May 2008 20:35:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Bryan Wu <cooloney@kernel.org>, Jie Zhang <jie.zhang@analog.com>,
       Oliver Neukum <oliver@neukum.org>, <david-b@pacbell.net>,
       <greg@kroah.com>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC-PATCH] lib: add byteorder helpers for the aligned case
In-Reply-To: <1210961386.5915.43.camel@brick>
Message-ID: <Pine.LNX.4.44L0.0805162022050.13416-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008, Harvey Harrison wrote:

> Some users know the pointer they are writing to are aligned,
> rather than doing *(__le16 *)ptr = cpu_to_le16(val) add helpers
> wrapping this up that have the same convention as put_unaligned_le/be.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Alan, as requested, I'm looking around a bit to see if there are actual
> users for this.  But it does make a nice complement to the unaligned
> versions.

This is great -- thanks!  I've wanted this sort of thing for a long
time.  There's a good chance that the SCSI core could make use of
it.  Try looking at the prep functions in sd.c and sr.c.

> +static inline void put_le16(u16 val, void *ptr)
> +{
> +	*(__le16 *)ptr = cpu_to_le16(val);
> +}

Is this able to do the byte rearrangement at compile time if val is a 
compile-time constant?  I imagine it would.

Alan Stern

