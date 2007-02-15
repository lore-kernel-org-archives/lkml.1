Return-Path: <linux-kernel-owner+w=401wt.eu-S932701AbXBONHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbXBONHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 08:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932700AbXBONHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 08:07:35 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:37748 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932697AbXBONHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 08:07:34 -0500
Date: Thu, 15 Feb 2007 13:53:42 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andreas Gruenbacher <agruen@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Neil Brown <neilb@suse.de>,
       Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       walt <wa1ter@myrealbox.com>
Subject: Re: [PATCH] Fix d_path for lazy unmounts
In-Reply-To: <200702141457.51218.agruen@suse.de>
Message-ID: <Pine.LNX.4.61.0702151349400.786@yvahk01.tjqt.qr>
References: <200702021923.02491.agruen@suse.de>
 <Pine.LNX.4.64.0702140730350.3604@woody.linux-foundation.org>
 <200702141139.41465.agruen@suse.de> <200702141457.51218.agruen@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Feb 14 2007 14:57, Andreas Gruenbacher wrote:
>[2]
>    ------------------------
>pipe:			"pipe:[439336]" (or "pipe/[439336]")
>
>[3] Always make disconnected paths double-slashed:
>--------------------------------------------------
>pipe:			"//pipe/[439336]"
>lazily umounted dir:	"//dir/file"
>lazily unmounted fs:	"//file"
>unreachable root:	"//"
>
>Opinions?

As for [2]/[3]:

What's the point in changing pipefs... you can *never*
reach it *anyway*, even if it was a /-style path, since
pipefs is a NOMNT filesystem.

That said, programs like lsof might break when it changes
away from "pipe:[integer]" (same goes for socket:, etc.)


Jan
-- 
