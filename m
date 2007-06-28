Return-Path: <linux-kernel-owner+w=401wt.eu-S1764015AbXF1Ccc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764015AbXF1Ccc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 22:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761487AbXF1CcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 22:32:23 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:42129 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758170AbXF1CcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 22:32:23 -0400
Message-ID: <46831CD8.8000502@gmail.com>
Date: Thu, 28 Jun 2007 04:28:40 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Patrick Draper <pdraper@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <200706271825.17459.ahartmetz@gmail.com> <46829E82.6080804@gmail.com> <200706272110.50744.ahartmetz@gmail.com> <4682EEDD.4020501@gmail.com> <4682FE5C.5070004@gmail.com> <468315AF.1080105@gmail.com>
In-Reply-To: <468315AF.1080105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2007 03:58 AM, Rene Herman wrote:

> to figure it out. If you need to specify an ALSA device somewhere, make 
> sure it's not the old "hw:0" but "default" (or "default:0" for the first
> card, "default:1" for the second, ...). The "hw:N" devices don't do
> mixing.

Slight correction/expansion -- don't do _software_ mixing. Some cards can do 
hardware mixing and in that case, "hw:N" or, specifically "hw:N,0", "hw:N,1" 
and so on devices are available as hardware mixed devices.

Try a cat /proc/asound/card0/pcm0p/info and check the "subdevices_count" for 
the number of hardware mixed playback devices you have available. If it's 1, 
your card should've been configured (by ALSA itself) to use software mixing 
by default and if it's higher than 1, it should not have been and will use 
hardware mixing...

Rene.
