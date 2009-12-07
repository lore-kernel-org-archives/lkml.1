Return-Path: <linux-kernel-owner+w=401wt.eu-S935214AbZLGO0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935214AbZLGO0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 09:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935178AbZLGO0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 09:26:07 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59874 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935157AbZLGO0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 09:26:06 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: miklos@szeredi.hu, miklos@szeredi.hu, luto@mit.edu,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20091207141321.0964461d@lxorguk.ukuu.org.uk> (message from Alan
	Cox on Mon, 7 Dec 2009 14:13:21 +0000)
Subject: Re: [PATCH v3] vfs: new O_NODE open flag
References: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu>
	<20091202191549.1dbffa2e@lxorguk.ukuu.org.uk>
	<E1NFva6-0001AI-0J@pomaz-ex.szeredi.hu>
	<20091202204828.4fa0c108@lxorguk.ukuu.org.uk>
	<E1NG4WJ-00026r-GE@pomaz-ex.szeredi.hu>
	<4B1A7159.3070101@mit.edu>
	<E1NH0Ub-0007oy-43@pomaz-ex.szeredi.hu>
	<20091205202838.3456b6fc@lxorguk.ukuu.org.uk>
	<E1NH1MB-0007v8-Ps@pomaz-ex.szeredi.hu>
	<20091205231304.03a4af61@lxorguk.ukuu.org.uk>
	<E1NHWlu-00029N-1t@pomaz-ex.szeredi.hu>
	<20091207122346.6d18a8e1@lxorguk.ukuu.org.uk>
	<E1NHctp-00032C-A1@pomaz-ex.szeredi.hu>
	<E1NHd0J-000345-Kw@pomaz-ex.szeredi.hu>
	<20091207130339.620b904b@lxorguk.ukuu.org.uk>
	<E1NHdJy-00037l-Jb@pomaz-ex.szeredi.hu>
	<20091207131546.2af06647@lxorguk.ukuu.org.uk>
	<E1NHdS9-00039i-B6@pomaz-ex.szeredi.hu> <20091207141321.0964461d@lxorguk.ukuu.org.uk>
Message-Id: <E1NHeXH-0003Lb-3q@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 07 Dec 2009 15:25:59 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Alan Cox wrote:
> > > That is *exactly* the problem, which is clearly what you are missing here.
> > 
> > I don't think so, but maybe I'm wrong.  Could you describe your attack
> > scenario in detail then, please?
> 
> First obvious attack: get an O_NODE handle to a device you have assigned
> to your ownership
> 
> 	while(1)
> 		fchmod(fd, 0666);
> 
> wait for device to unload, reload and be intended for another user
> Race udev to a real open. You have a similar problem with vhangup() and
> ttys.

If this was a udev device, the same attack is possible with a hard
link to the device.  Except the attacker simply does link() instad of
open(O_NODE) and chmod() instead of fchmod().

See?

Thanks,
Miklos
