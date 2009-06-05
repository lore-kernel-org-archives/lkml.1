Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZFEUJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZFEUJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 16:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZFEUJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 16:09:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247AbZFEUJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 16:09:36 -0400
Date: Fri, 5 Jun 2009 13:08:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: corentincj@iksaif.net, acpi4asus-user@lists.sourceforge.net,
       len.brown@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
Message-Id: <20090605130835.e21eaf37.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0906051157460.22218@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0906051157460.22218@melkki.cs.Helsinki.FI>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009 11:59:41 +0300 (EEST)
Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

>  /*
> + * Camera helpers
> + */
> +
> +static void eeepc_enable_camera(void)
> +{
> +	int err;
> +
> +	err = set_acpi(CM_ASL_CAMERA, 1);
> +	if (err)
> +		printk(EEEPC_WARNING "Unable to enable camera %d\n", err);
> +}
> +
> +/*
>   * Sys helpers
>   */
>  static int parse_arg(const char *buf, unsigned long count, int *val)
> @@ -996,6 +1009,9 @@ static int __init eeepc_laptop_init(void)

We can do this:

--- a/drivers/platform/x86/eeepc-laptop.c~eeepc-laptop-enable-camera-by-default-fix
+++ a/drivers/platform/x86/eeepc-laptop.c
@@ -334,7 +334,7 @@ static const struct rfkill_ops eeepc_rfk
  * Camera helpers
  */
 
-static void eeepc_enable_camera(void)
+static void __init eeepc_enable_camera(void)
 {
 	int err;
 
_

if we're so inclined?
