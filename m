Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbXFNS07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbXFNS07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 14:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbXFNS0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 14:26:52 -0400
Received: from lazybastard.de ([212.112.238.170]:53431 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbXFNS0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 14:26:52 -0400
Date: Thu, 14 Jun 2007 20:22:02 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext2 on flash memory
Message-ID: <20070614182201.GD31984@lazybastard.org>
References: <20070611101319.GA14284@DervishD> <20070614174509.GB31984@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070614174509.GB31984@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 June 2007 19:45:10 +0200, Jörn Engel wrote:
> 
> Nearly two years ago I have spoken to a person that reverse engineered
> the behaviour of several chips used in pendrives.  At the time that
> reverse engineering apparently covered most of the market.  The details
> were quite lengthy but can be condensed to two words: Smartmedia format.

Maybe I should add that things have allegedly improved.  Many devices
today support both static and dynamic wear leveling.  Dynamic wear
leveling is what smartmedia does.  It depends on the filesystem writing
somewhere to move those blocks.  Static wear leveling will also move
blocks that are not written.

However, the exact nature of wear leveling is not disclosed.  And I see
no reason to trust an undisclosed "static and dynamic wear leveling" any
more than I trust smartmedia.

I will even go further and claim that nothing short of a filesystem can
do proper wear leveling across the complete device.  The reason
smartmedia introduced "areas" was to bound the time until it's map is
created and the device can get accessed.  If the map spanned a large
64GB device, access times would go sky-high.

Any method I can imagine to offer good wear leveling will result in
either a filesystem or at least a simplified one-file-system with the
only file being the "block device" exported outward.  So naturally my
answer to the problem is called LogFS. :)

Jörn

-- 
It's not whether you win or lose, it's how you place the blame.
-- unknown
