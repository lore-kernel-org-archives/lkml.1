Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710AbYAWNdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbYAWNdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 08:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYAWNde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 08:33:34 -0500
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:17488 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbYAWNdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 08:33:33 -0500
To: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [PATCH 1/2] dm-band: The I/O bandwidth controller: Source code  patch
Cc: containers@lists.linux-foundation.org, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
In-reply-To: <20080123.215632.226773739.ryov@valinux.co.jp>
References: <20080123.215350.193721890.ryov@valinux.co.jp> <20080123.215632.226773739.ryov@valinux.co.jp>
Message-Id: <E1JHfjM-0003NV-BR@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Wed, 23 Jan 2008 14:33:28 +0100
X-OriginalArrivalTime: 23 Jan 2008 13:33:30.0778 (UTC) FILETIME=[8B0AE7A0:01C85DC4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm not qualified to comment on the code, but here are some suggestions on
config option and comments.

Cheers,
FJP

Ryo Tsuruta wrote:
> +config DM_BAND
> +	tristate "I/O band width control "

s/band width/bandwidth/
(it seems to be used correctly elsewhere, but you may want to double-check)

> +	depends on BLK_DEV_DM
> +	---help---
> +	Any processes or cgroups can use the same storage
> +	with its band-width fairly shared.

s/band-width/bandwidth/

The help should probably be a bit more verbose as this does not tell anybody
much who has not already read the documentation.

Maybe something like:
<snip>
This device-mapper target allows to define how the
available bandwith of a storage device should be
shared between processes or cgroups.

Information on how to use dm-band is available in:
   Documentation/device-mapper/band.txt
</snip>

> + * The following functiotons determine when and which BIOs should
                    ^^^^^^^^^^^
> + * be submitted to control the I/O flow.
> + * It is possible to add a new I/O scheduling policy with it.

> + *  <Method>      <description>
> + * g_can_submit   : To determine whether a given group has a right to

s/a right/the right/

> + *                  submit BIOs.
> + * 		    The larger return value the higher priority to submit.
> + * 		    Zero means it has no right.

"The larger the return value, the higher the priority [...]"

> + * g_prepare_bio  : Called right before submitting each BIO.
> + * g_restart_bios : Called when there exist some BIOs blocked but none of
> them
> + * 		    can't be submitted now.

s/when there exist some BIOs blocked/if some BIOs exist that are blocked/ ?

"none of them can't" : the double negative looks incorrect (and should be
avoided anyway)

> + *		    This method have to do something to restart to submit BIOs.

s/have/has/

"has to do something" : that's rather vague...
