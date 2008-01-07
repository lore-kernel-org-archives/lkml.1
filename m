Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbYAGMzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbYAGMzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 07:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbYAGMzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 07:55:45 -0500
Received: from lazybastard.de ([212.112.238.170]:45239 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbYAGMzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 07:55:44 -0500
Date: Mon, 7 Jan 2008 13:49:52 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Frantisek Rysanek <Frantisek.Rysanek@post.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [noob q. on block layer] block IO read-ahead during sequential *write*?
Message-ID: <20080107124952.GA8201@lazybastard.org>
References: <47822835.4182.1ADF8AE7@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47822835.4182.1ADF8AE7@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 January 2008 13:25:09 +0100, Frantisek Rysanek wrote:
> 
> let me start with a simple example. The following commands:
> 
>  cp /dev/zero /dev/hda
>  dd if=/dev/zero of=/dev/hda [bs=512]
> 
> both have one common side-effect: apart from the disk being properly 
> overwritten with zeroes, the kernel seems to keep reading sectors 
> ahead of the current seek position of the sequential write.

Block devices are cached in the page cache.  If you write less than a
full page, any remainder has to be read from the device.

If you retry the dd with bs=4096 (or whatever your architecture's page
size happens to be), does this still occur?

Jörn

-- 
Chance favors only the prepared mind.
-- Louis Pasteur
