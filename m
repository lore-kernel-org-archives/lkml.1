Return-Path: <linux-kernel-owner+w=401wt.eu-S1759751AbYHCWAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759751AbYHCWAc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 18:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757306AbYHCWAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 18:00:24 -0400
Received: from xenotime.net ([66.160.160.81]:53536 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756682AbYHCWAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 18:00:23 -0400
Date: Sun, 3 Aug 2008 15:00:19 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Erkki Lintunen <ebirdie@iki.fi>
cc: rdunlap@xenotime.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: bugfix for scripts/patch-kernel in 2.6 sublevel stepping
In-Reply-To: <48961C6E.50000@iki.fi>
Message-ID: <Pine.LNX.4.64.0808031458180.20768@shark.he.net>
References: <48961C6E.50000@iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008, Erkki Lintunen wrote:

> scripts/patch-kernel script can't patch a tree, say, from 2.6.25 to 2.6.26.1,
> because of a wrong comparison in context of patching 2.6.x base. Following
> patch has a fix for it.
> 
> Erkki

Hi,

This does work better than the current script in the kernel tree.

The larger question:  is does anyone still use this script?

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


Andrew, please merge.


> --- linux-2.6.26/scripts/patch-kernel   2008-04-27 19:49:14.000000000 +0300
> +++ linux-2.6.26.1/scripts/patch-kernel 2008-08-03 23:34:00.000000000 +0300
> @@ -213,6 +213,7 @@
>  if [ $stopvers != "default" ]; then
>         STOPSUBLEVEL=`echo $stopvers | cut -d. -f3`
>         STOPEXTRA=`echo $stopvers | cut -d. -f4`
> +       STOPFULLVERSION=${stopvers%%.$STOPEXTRA}
>         #echo "#___STOPSUBLEVEL=/$STOPSUBLEVEL/, STOPEXTRA=/$STOPEXTRA/"
>  else
>         STOPSUBLEVEL=9999
> @@ -249,7 +250,7 @@
>  do
>      CURRENTFULLVERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL"
>      EXTRAVER=
> -    if [ $stopvers = $CURRENTFULLVERSION ]; then
> +    if [ $STOPFULLVERSION = $CURRENTFULLVERSION ]; then
>          echo "Stopping at $CURRENTFULLVERSION base as requested."
>          break
>      fi

-- 
~Randy
