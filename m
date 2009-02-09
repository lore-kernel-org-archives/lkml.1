Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbZBIV46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbZBIV46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZBIV4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:56:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbZBIV4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:56:50 -0500
Date: Mon, 9 Feb 2009 13:56:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, ian@beware.dropbear.id.au
Subject: Re: [1/1] w1: w1 temp calculation overflow fix.
Message-Id: <20090209135641.0367a71f.akpm@linux-foundation.org>
In-Reply-To: <20090209214217.GA14958@ioremap.net>
References: <20090209214217.GA14958@ioremap.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009 00:42:17 +0300
Evgeniy Polyakov <zbr@ioremap.net> wrote:

> Signed-off-by: Ian Dall <ian@beware.dropbear.id.au>
> Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>

I assumed from the above that Ian authored this patch.  Please let me
know if that was incorrect.

The way to track authorship is to put the originator's From: line at
the top of the changelog.

> diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
> index 2c8dff9..1ed3d55 100644
> --- a/drivers/w1/slaves/w1_therm.c
> +++ b/drivers/w1/slaves/w1_therm.c
> @@ -115,7 +115,7 @@ static struct w1_therm_family_converter w1_therm_families[] = {
>  
>  static inline int w1_DS18B20_convert_temp(u8 rom[9])
>  {
> -	s16 t = (rom[1] << 8) | rom[0];
> +	int t = ((s16)rom[1] << 8) | rom[0];
>  	t = t*1000/16;
>  	return t;
>  }

It seems strange to use s16 here, but it will fix the bug.

Perhaps this function should be using plain old `unsigned' everywhere.

Please provide changelogs.  This bugfix is applicable to 2.6.28.x and
probably earlier.  But due to the lack of any supporting information I
am not in a position to determine whether it should be backported.



