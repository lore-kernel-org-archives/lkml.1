Return-Path: <linux-kernel-owner+w=401wt.eu-S1758663AbYIMIf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663AbYIMIf3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 04:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYIMIfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 04:35:22 -0400
Received: from cpsmtpo-eml03.kpnxchange.com ([213.75.38.152]:28369 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752574AbYIMIfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 04:35:21 -0400
From: Frans Pop <elendil@planet.nl>
To: Jonathan McDowell <noodles@earth.li>
Subject: Re: [PATCH] Fixup deb-pkg target to generate separate firmware deb.
Date: Sat, 13 Sep 2008 10:35:18 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20080912112042.GX30927@earth.li>
In-Reply-To: <20080912112042.GX30927@earth.li>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809131035.18477.elendil@planet.nl>
X-OriginalArrivalTime: 13 Sep 2008 08:35:19.0213 (UTC) FILETIME=[A7803DD0:01C9157B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 September 2008, Jonathan McDowell wrote:
> The below is a simplistic fix for "make deb-pkg"; it splits the
> firmware out to a linux-firmware-image package and adds an
> (unversioned) Suggests to the linux package for this firmware.
>
> Frans, does this solve your problem in an acceptable manner?

Yes it does. Thanks for the patch Jonathan.
Tested both with kernel configs that result in firmware and that do not 
result in firmware.

A few minor nitpicks below.

> Signed-Off-By: Jonathan McDowell <noodles@earth.li>

Acked-by: Frans Pop <elendil@planet.nl>

> @@ -118,8 +122,24 @@ fi 
>  chown -R root:root "$tmpdir"
>  chmod -R go-w "$tmpdir"
>
> +# Do we have firmware? Move it out of the way and build it into a
> package. +if [ -e "$tmpdir/lib/firmware" ]; then
> +	mv "$tmpdir/lib/firmware" "$fwdir/lib/"
> +
> +cat <<EOF >> debian/control

This line should be indented one level.

> +
> +Package: $fwpackagename
> +Architecture: any
> +Description: Linux kernel firmware, version $version
> + This package contains firmware from the Linux kernel, version
> $version
> +EOF 
> +
> +dpkg-gencontrol -isp -p$fwpackagename -P"$fwdir"
> +dpkg --build "$fwdir" ..

Same for these two lines.

> +fi
> +
>  # Perform the final magic
> -dpkg-gencontrol -isp
> +dpkg-gencontrol -isp -p$packagename
>  dpkg --build "$tmpdir" ..
>
>  exit 0
> -----
>
> J.

