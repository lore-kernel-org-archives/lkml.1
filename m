Return-Path: <linux-kernel-owner+w=401wt.eu-S932941Ab0AFWAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab0AFWAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932917Ab0AFWAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:00:13 -0500
Received: from emroute4.ornl.gov ([160.91.86.27]:53167 "EHLO emroute4.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932912Ab0AFWAM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:00:12 -0500
X-Greylist: delayed 2704 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jan 2010 17:00:12 EST
Date: Wed, 06 Jan 2010 16:15:04 -0500
From: David Dillow <dave@thedillows.org>
Subject: Re: [PATCH] log2.h: Macro-ize is_power_of_2() for use in BUILD_BUG_ON
In-reply-to: <aday6kbt14a.fsf@roland-alpha.cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Bart Van Assche <bart.vanassche@gmail.com>
Message-id: <1262812504.2265.0.camel@lap75545.ornl.gov>
MIME-version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12)
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
References: <ada3a2jugqu.fsf@roland-alpha.cisco.com>
 <20100106123306.ac85e557.akpm@linux-foundation.org>
 <aday6kbt14a.fsf@roland-alpha.cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 12:44 -0800, Roland Dreier wrote:
> > Perhaps we can avoid worrying about that via
> 
>  > #define BUILD_BUG_ON_NOT_POWER_OF_2(n)	\
>  > 	BUILD_BUG_ON((n != 0 && ((n & (n - 1)) == 0)))
> 
> Having something so specific to this particular case makes me feel like
> maybe it's just not worth it.  At least in the case I'm looking at, we
> could just have:
> 
> /*
>  * The code relies on FOO being a power of 2.  If you break this,
>  * you're dumb.
>  */
> #define FOO_SHIFT	6
> #define FOO		(1 << FOO_SHIFT)
> 
> Your thoughts?

I'm fine with that, but now I'll probably be the dumb one to break it
some day in the future.
