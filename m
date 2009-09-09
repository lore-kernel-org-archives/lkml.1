Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbZIIUj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbZIIUj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 16:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbZIIUj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 16:39:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897AbZIIUj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 16:39:57 -0400
Date: Wed, 9 Sep 2009 13:39:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       FlorianSchandinat@gmx.de
Subject: Re: [PATCH 3/3] viafb: use read-only mode parsing
Message-Id: <20090909133956.c682bf4a.akpm@linux-foundation.org>
In-Reply-To: <1252290284-3668-3-git-send-email-FlorianSchandinat@gmx.de>
References: <1252290284-3668-1-git-send-email-FlorianSchandinat@gmx.de>
	<1252290284-3668-2-git-send-email-FlorianSchandinat@gmx.de>
	<1252290284-3668-3-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  7 Sep 2009 02:24:44 +0000
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> +static void parse_mode(const char *str, u32 *xres, u32 *yres)
> +{
> +	char *ptr;
> +
> +	*xres = simple_strtoul(str, &ptr, 10);
> +	if (ptr[0] != 'x')
> +		goto out_default;
> +
> +	*yres = simple_strtoul(&ptr[1], &ptr, 10);
> +	if (ptr[0])
> +		goto out_default;
> +
> +	return;
> +
> +out_default:
> +	printk(KERN_WARNING "viafb received invalid mode string: %s\n", str);
> +	*xres = 640;
> +	*yres = 480;
> +}

One wonders if we could use sscanf here?

The second simple_strtoul() could use strict_strtoul(), but that's not
obviously superior IMO.

