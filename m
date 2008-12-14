Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbYLNQO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbYLNQO2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 11:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbYLNQOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 11:14:19 -0500
Received: from ns2.gothnet.se ([82.193.160.251]:14513 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753363AbYLNQOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 11:14:18 -0500
X-Greylist: delayed 989 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Dec 2008 11:14:17 EST
Message-ID: <49452CEE.1090909@shipmail.org>
Date: Sun, 14 Dec 2008 16:57:34 +0100
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: David Airlie <airlied@linux.ie>,
       dri-devel <dri-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: BUG: via_drmclient.h is referenced but does not exist
References: <20081213193506.GA22969@uranus.ravnborg.org>
In-Reply-To: <20081213193506.GA22969@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

The intention is for via_drm.h to be self-containing when included both 
for a kernel build and for a user-space build. In this particular case, 
via_drmclient.h lives in the user-space clients and includes stdint.h to 
get access to uint32_t and friends.

Of course, the user-space clients could
#include "uint32.h"
#include "via_drm.h"

but shouldn't really the tools be mimicing what the compiler does in 
this case?

/Thomas


Sam Ravnborg wrote:
> Hi David et al.
>
> After improving the headers_check.pl script to do a
> check for files included with:
>
> 	#include "foo.h"
>
> it reported the following error:
>
> /home/sam/kernel/knext.git/usr/include/drm/via_drm.h:34: included file '/home/sam/kernel/knext.git/usr/include/drm/via_drmclient.h' is not exported
>
> And indeed the file via_drmclient.h does not exist in the kernel source.
> We do not see any issue in the kernel as the include is guarded by:
>
> #ifndef __KERNEL__
> #include "via_drmclient.h"
> #endif
>
> But referring to a non-existing file is not the right thing to to.
>
> We need this check as we have several places where we do:
>
> 	#include "foo.h"
>
> in our exported headers.
>
> So we need to fix drm somehow.
>
> The headers_check.pl patch is included for reference.
>
>   



