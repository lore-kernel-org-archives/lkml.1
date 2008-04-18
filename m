Return-Path: <linux-kernel-owner+w=401wt.eu-S1758936AbYDRRsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbYDRRsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 13:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758187AbYDRRsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 13:48:35 -0400
Received: from rv-out-0708.google.com ([209.85.198.248]:62450 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758453AbYDRRse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 13:48:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=oNQZyaUBnk/E9l+YivDaAKmJx3uhz0J9qj0hUJeZRZZBEPb+pAXk9yfvM6bs3/lPDQpiWcRg/dA7lVmzCS/E/gaatiJwSCkhJoDNUcJldKCJKeL3iJ9zm2br8XA9eqrVLiZ6a+hGzu7H2MoCafIS6oopumiTiIZNwUeV146FLhM=
Message-ID: <b6c5339f0804181048u1567529dt8950e5da1875f3ac@mail.gmail.com>
Date: Fri, 18 Apr 2008 13:48:31 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Szabolcs Szakacsits" <szaka@ntfs-3g.org>
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, hch@infradead.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0804181958560.29728@dhcppc2>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com>
	 <20080412205544.5e12a7d4.akpm@linux-foundation.org>
	 <20080413080130.GA9622@infradead.org>
	 <20080413012001.8d7967f4.akpm@linux-foundation.org>
	 <20080413082815.GA20108@infradead.org>
	 <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
	 <20080414004521.GA30489@hash.localnet>
	 <Pine.LNX.4.61.0804181302180.29728@dhcppc2>
	 <b6c5339f0804180651m2a291755ke093bda3bea1d2b4@mail.gmail.com>
	 <Pine.LNX.4.61.0804181958560.29728@dhcppc2>
X-Google-Sender-Auth: 3df351095998355c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 1:35 PM, Szabolcs Szakacsits <szaka@ntfs-3g.org> wrote:
>  The major reason seems to be that the FUSE version reads heavily from the
>  block device during pure write operations, while the kernel driver never.
>  There can be several non-exclusive explanations.

Yep, I suspect switching to the lower-level API plus switching to mmap()
and getting rid of various memcpy's in omfs.c would make a huge difference.
And also drop the line count without the hash table stuff.

>  Moreover when you're writing to a block device from user space then the
>  size and position of the block should be page aligned, otherwise you end up
>  doing unwanted synchronous reads instead of the believed asynchronous
>  writes.

Cool, thanks for the tips!

-- 
Bob Copeland %% www.bobcopeland.com
