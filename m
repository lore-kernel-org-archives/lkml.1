Return-Path: <linux-kernel-owner+w=401wt.eu-S1760191AbXKUOtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191AbXKUOtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 09:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbXKUOsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 09:48:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49425 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbXKUOsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 09:48:50 -0500
Date: Wed, 21 Nov 2007 14:48:35 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Dave Jones <davej@redhat.com>, maximilian attems <max@stro.at>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANN] Squashfs 3.3 released
Message-ID: <20071121144835.GA7556@infradead.org>
References: <472EFACA.1090308@lougher.demon.co.uk> <20071105115624.GJ14432@baikonur.stro.at> <4731E880.6010303@lougher.demon.co.uk> <20071120235048.GA15764@redhat.com> <47443A83.2020607@lougher.demon.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47443A83.2020607@lougher.demon.co.uk>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 02:02:43PM +0000, Phillip Lougher wrote:
> Unfortunately the move to fixed little endian filesystem will involve 
> another filesystem layout change.  The current filesystem layout still 
> uses packed bitfield structures, and it is impossible to swap these 
> using the standard kernel swap macros.  Removal of my routines that can 
> properly swap packed bitfield structures is another change demanded by 
> the Linux kernel mailing list.

The normal way to do it is to use shift and mask after doing the endian
conversion.  But the problem with bitfields is that they can have different
kinds of layouts depending on the compiler or abi which is another reason
to avoid them in ondisk/wire formats.
