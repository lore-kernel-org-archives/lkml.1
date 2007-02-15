Return-Path: <linux-kernel-owner+w=401wt.eu-S932700AbXBONTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700AbXBONTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 08:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932725AbXBONTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 08:19:55 -0500
Received: from ns2.suse.de ([195.135.220.15]:37139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932700AbXBONTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 08:19:54 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] Fix d_path for lazy unmounts
Date: Thu, 15 Feb 2007 05:19:38 -0800
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Neil Brown <neilb@suse.de>,
       Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       walt <wa1ter@myrealbox.com>
References: <200702021923.02491.agruen@suse.de> <200702141457.51218.agruen@suse.de> <Pine.LNX.4.61.0702151349400.786@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0702151349400.786@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702150519.39299.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 February 2007 04:53, Jan Engelhardt wrote:
> What's the point in changing pipefs... you can *never*
> reach it *anyway*, even if it was a /-style path, since
> pipefs is a NOMNT filesystem.

The point is that we could then get rid of the special case for MS_NOUSER 
filesystems like pipefs in __d_path(). (This special case caused the lazy 
unmounted dir bug in the first place.) It is likely not really worth it, 
though.

Andreas
