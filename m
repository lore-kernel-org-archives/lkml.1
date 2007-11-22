Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbXKVSxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbXKVSxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 13:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbXKVSxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 13:53:33 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:2614 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbXKVSxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 13:53:32 -0500
Date: Thu, 22 Nov 2007 19:53:30 +0100
From: Olivier Galibert <galibert@pobox.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Why is FIBMAP ioctl root only?
Message-ID: <20071122185330.GA13225@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	linux-kernel@vger.kernel.org
References: <20071122181714.GB6299@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122181714.GB6299@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2007 at 07:17:14PM +0100, Jan Kara wrote:
>   Hi,
> 
>   I guess subject says it all - why is FIBMAP ioctl restricted only to
> root (CAP_SYS_RAWIO)? Corresponding ioctl for XFS is allowed without any
> special capabilities so we are inconsistent here too...
>   Would anyone mind if the check is removed?

Once upon a time some filesystems fucked up when incorrect values
(negative offsets in particular).  So the easy way out was taken and
FIBMAP was restricted, to the eternal annoyance of DVD players which
needed the sector number for CSS reasons.  Since then dvd players have
included an udf parser and life went on.

Well, psx movie players needed it too, but bah.

Essentially if you remove the restriction you have to audit all
filesystems to be sure that they're not going to be problematic.

  OG.

