Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab0CIN3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 08:29:20 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:52962 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab0CIN3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 08:29:15 -0500
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 08:29:15 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CpsQ1uSgJriA45LrXrLsFcATw6aUSoW617eTelTeDgpaQ/TPGtkKCKvJ5ThyPFUR1U
         R/tO7CgT8EJnnamxxGUh0/VAdkFEfig6bjkVHCb5mgtASknKJCwNt+HDvKEsYyVZSL+C
         QWTpuxYLlYOxusNQ5VfbNQ6XcSOHiefxfhxhs=
Message-ID: <4B964BBD.3070707@gmail.com>
Date: Tue, 09 Mar 2010 08:23:09 -0500
From: jim owens <owens6336@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg Freemyer <greg.freemyer@gmail.com>
CC: David Newall <davidn@davidnewall.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Jeff Garzik <jeff@garzik.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: defrag deployment status (was Re: [PATCH] ext4: allow defrag
 	(EXT4_IOC_MOVE_EXT) in 32bit compat mode)
References: <201003072132.10579.borntraeger@de.ibm.com>	 <4B94367E.9080506@garzik.org>	 <201003080853.42978.borntraeger@de.ibm.com>	 <4B9518DA.8010201@davidnewall.com> <4B952437.8020607@gmail.com> <87f94c371003080831n4d310e10i2b9badf4290f1ede@mail.gmail.com> <4B952FB5.2060600@gmail.com>
In-Reply-To: <4B952FB5.2060600@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After thinking about it overnight, I realized I think in terms
of 1 drive is 1 filesystem.  That is a fatal trap for defragment.
 
> When I only worried about a few OEM drives, I used to read the zone
> geometry from the drive to see where each speed transition was as the
> density decreased.  But that is just not worth the effort in linux
> filesystems IMO, it is enough to pack low.

So I retract that we don't care about zone geometry, we need to
care deeply, but not in the sense of how moving short distances
on a drive affects the performance.  What we need to ensure is
that the placer algorithm does not span across partitions as in:

["/" 100GB created] [300GB other] [100G LVM added to "/"]

so the filesystem thinks it is 200GB contiguous and the
defragmenter thinks address 90GB is closer to address 110 GB
than 90GB is to 50GB.

jim
