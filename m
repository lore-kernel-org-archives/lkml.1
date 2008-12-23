Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbYLWXeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbYLWXeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 18:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYLWXeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 18:34:16 -0500
Received: from 1wt.eu ([62.212.114.60]:1246 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbYLWXeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 18:34:16 -0500
Date: Wed, 24 Dec 2008 00:34:10 +0100
From: Willy Tarreau <w@1wt.eu>
To: Martin Schlemmer <Martin.Schlemmer@nwu.ac.za>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Initramfs from existing vmlinuz
Message-ID: <20081223233410.GC6800@1wt.eu>
References: <49518245.3D93.006F.0@nwu.ac.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49518245.3D93.006F.0@nwu.ac.za>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2008 at 12:28:53AM +0200, Martin Schlemmer wrote:
> Hi
> 
> I had a bit of an accident, and wondered if somebody already had to try to extract the initramfs image from an existing vmlinuz?
> 
>  I did try google, but either my search terms was not right, or nobody really touched on the subject before, because all the results mostly dealt with an external image.
> 
> Any advice will be appreciated.

yes, it happens to me from time to time.
You first have to extract and uncompress the ELF image from vmlinuz. For
this, look for the gzip signature 1F 8B 08 in your vmlinuz, and feed all
data starting from this point to zcat. Either you do the same on the
resulting file -and you may find several compressed images- or you simply
pass it through "objdump -h". It will show you a .init.ramfs section. Use
the fourth field as the file offset, and dump from that position. You'll
find your initramfs, likely starting with 1F 8B 08 since it's supposed
to be compressed with gzip.

You need an hex editor, dd, zcat and objdump for this. It's not much
complicated once you have the tools, but it might require a few attempts
before finding the right image (I tend to find config.gz before initramfs).

Regards,
Willy

