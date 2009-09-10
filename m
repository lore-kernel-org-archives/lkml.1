Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbZIJByG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbZIJByG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 21:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbZIJByF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 21:54:05 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:49941
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754815AbZIJByE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 21:54:04 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz1432R98dNzz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KPQFXZ-02-6MI-02
X-M-MSG: 
Date: Thu, 10 Sep 2009 09:55:09 +0800
From: Crane Cai <crane.cai@amd.com>
To: Jean Delvare <khali@linux-fr.org>
CC: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2] I2C: Add support for new AMD SMBus devices
Message-ID: <20090910015509.GA3147@crane-desktop>
Mail-Followup-To: Crane Cai <crane.cai@amd.com>,
	Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
	linux-i2c@vger.kernel.org
References: <20090811014921.GB29858@crane-desktop> <20090909111026.21e85f54@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20090909111026.21e85f54@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 10 Sep 2009 01:53:54.0174 (UTC) FILETIME=[8D3C71E0:01CA31B9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 11:10:26AM +0200, Jean Delvare wrote:
> This is better, however I still have concerns:
> 
> * Your device ID comparison is fragile. Are you absolutely certain that
>   you know _all_ the SMBus devices that were released by AMD in the
>   past? If anything, I'd rather have a single comparison on the first
>   device ID that _will_ be supported by the i2c-piix4 driver.
> 
> * Are you absolutely certain that AMD will never ever release an
>   incompatible SMBus device in the future? I doubt it. In the past,
>   various vendors have changed their implementations. Intel changed
>   twice (i2c-piix4 -> i2c-i801 -> i2c-isch), AMD once already
>   (i2c-amd756 -> i2c-amd8111), VIA once (i2c-via -> i2c-viapro), nVidia
>   once (i2c-amd756 -> i2c-nforce2), etc. If history repeats itself (and
>   it often does), I wouldn't be surprised to see future AMD SMBus chips
>   not compatible with the i2c-piix4 driver, while with your patch
>   applied, the driver would claim to support them. Binding a driver to
>   an unsupported chip can have unpredictable, potentially bad
>   consequences, and I'd rather have the driver not bind immediately to
>   new supported devices than bind to unsupported ones.
> 
> * With your patch, the i2c-piix4 driver would load automatically on
>   systems which do not need it (all old AMD-based PC systems.) While a
>   minor issue, this is still a waste of boot time and memory for these
>   users. I am not aware of any precedent of this.
> 
> So, all in all, I'd rather simply add the IDs of new supported devices
> as they are released, rather than implement this broad matching
> mechanism.
Thank you for your greate comments. I agree with you. And a new patch will be 
submitted which will use VID DID to check.

-- 
Best Regards,
- Crane

