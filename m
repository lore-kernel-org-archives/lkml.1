Return-Path: <linux-kernel-owner+w=401wt.eu-S1764522AbYJKHDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764522AbYJKHDe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761771AbYJKGwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:52:21 -0400
Received: from local.xorcom.com ([62.90.10.53]:48980 "EHLO local.xorcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761953AbYJKGwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:52:19 -0400
X-Greylist: delayed 1139 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Oct 2008 02:52:18 EDT
Date: Sat, 11 Oct 2008 08:33:10 +0200
From: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, David Rowe <david@rowetel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 16/23] Staging: add echo cancelation module
Message-ID: <20081011063310.GW31838@xorcom.com>
References: <20081010224130.GA30117@kroah.com> <1223678567-30143-16-git-send-email-greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223678567-30143-16-git-send-email-greg@kroah.com>
Organization: Xorcom*
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While there are a number of small issues in this code, I personally
would like to first and foremost get a usable interface so I could get a
working echo canceller module into dahdi:
http://svn.digium.com/svn/dahdi/linux/trunk/
http://svn.digium.com/svn/dahdi/linux/trunk/drivers/dahdi/

(Don't preach me that it should be included in mainline. Or if you do,
do it in a different thread, please)

1. echo.h (The interface) needlessly includes the definition of 
definition of echo_can_state_t. Anywhere in the interface it is used as
a pointer, including a _create and _destory function.

2. Furthermore, anybody that includes fir.h must also define malloc 
   first. See echo.c . fir.h is included for the definition of
   echo_can_state_t .

3. In that specific environment (dahdi/zaptel) echo_can is not a very
unique prefix. Thus in my provisional change I added oslec_ as a prefix.

I'm not sure how much (3) counts here.

My current working tree is in not in the best place: the debian
(non-existing) package dahdi-linux . See 

  http://svn.debian.org/viewsvn/pkg-voip?rev=6284&view=rev

I hope that once I get a clear enough interface I can kick out the oslec
subdirectory and move the EC module upstream.

Also:

On Fri, Oct 10, 2008 at 03:42:40PM -0700, Greg KH wrote:

> diff --git a/drivers/staging/echo/TODO b/drivers/staging/echo/TODO
> new file mode 100644
> index 0000000..1ca09af
> --- /dev/null
> +++ b/drivers/staging/echo/TODO
> @@ -0,0 +1,10 @@
> +TODO:

> +	- remove proc interface, only use echo.h interface (proc interface is
> +	  racy and not correct.)

Already done, right? I don't see any _wrapper.c around.

-- 
               Tzafrir Cohen
icq#16849755              jabber:tzafrir.cohen@xorcom.com
+972-50-7952406           mailto:tzafrir.cohen@xorcom.com
http://www.xorcom.com  iax:guest@local.xorcom.com/tzafrir
