Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbYC1NsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbYC1NsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbYC1Nr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 09:47:57 -0400
Received: from rtr.ca ([76.10.145.34]:2657 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbYC1Nr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 09:47:56 -0400
Message-ID: <47ECF70A.2060600@rtr.ca>
Date: Fri, 28 Mar 2008 09:47:54 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       jkosina@suse.cz, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, pavel@suse.cz, akpm@linux-foundation.org,
       rtc-linux@googlegroups.com
Subject: Re: 2.6.25-rc7: Ugh.
References: <20080327160700.GB828@suse.de> <200803272358.20081.david-b@pacbell.net> <20080328091645.GI21413@elte.hu> <200803280249.42193.david-b@pacbell.net>
In-Reply-To: <200803280249.42193.david-b@pacbell.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Friday 28 March 2008, Ingo Molnar wrote:
>>>> Could somebody please fix the RTC mess in kconfig now ?
>>> My version has been sitting in MM for a while now.
>> could you please provide an URL or the patch itself so that others who 
>> hit this issue and read this thread can apply the fix?
> 
> I merged the two patches (gentle, then harsh) so the result is
> smaller.  Here you go.
> 
> - dave
> 
> 
> ========== CUT HERE
> Prevent the most significant RTC configuration problems:
> 
>  - If the new RTC framework is enabled, don't allow any of the
>    legacy drivers to be configured.
> 
>  - When using generic RTC on x86, enable rtc-cmos by default.
> 
> It seems too many people are used to enabling a legacy RTC despite 
> the Kconfig help/comments; the gentle approach hasn't worked.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  drivers/char/Kconfig |    8 ++++++++
>  drivers/rtc/Kconfig  |    5 +----
>  2 files changed, 9 insertions(+), 4 deletions(-)
> 
> --- linux-2.6.orig/drivers/char/Kconfig	2008-03-28 02:35:58.000000000 -0700
> +++ linux-2.6/drivers/char/Kconfig	2008-03-28 02:39:17.000000000 -0700
> @@ -704,6 +704,12 @@ config NVRAM
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called nvram.
>  
> +#
> +# These legacy RTC drivers just cause too many conflicts with the generic
> +# RTC framework ... let's not even try to coexist any more.
...

Thanks, David.  Could you perhaps also update the option descriptions
to clearly indicate which set of RTCs are the new ones, and which are
the old ones that are going away someday?

I didn't find it at all obvious, and I still don't know which set my
configured kernel is actually using.

Thanks
