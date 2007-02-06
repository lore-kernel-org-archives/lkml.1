Return-Path: <linux-kernel-owner+w=401wt.eu-S932930AbXBFRwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbXBFRwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 12:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933040AbXBFRwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 12:52:25 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3211 "EHLO Perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932930AbXBFRwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 12:52:24 -0500
Subject: Re: [PATCH 2.6.20] isdn-capi: Use ARRAY_SIZE macro when appropriate
From: Joe Perches <joe@perches.com>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: kkeil@suse.de, kai.germaschewski@gmx.de, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
In-Reply-To: <20070206160446.GE8991@Ahmed>
References: <20070206160446.GE8991@Ahmed>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 09:52:17 -0800
Message-Id: <1170784337.3688.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 18:04 +0200, Ahmed S. Darwish wrote:
> A patch to use ARRAY_SIZE macro already defined in kernel.h
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> ---
> diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
> index d22c022..3804591 100644
> --- a/drivers/isdn/capi/capi.c
> +++ b/drivers/isdn/capi/capi.c
> @@ -1456,7 +1456,7 @@ static struct procfsentries {
>  
>  static void __init proc_init(void)
>  {
> -    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
> +    int nelem = ARRAY_SIZE(procfsentries);
>      int i;
>  
>      for (i=0; i < nelem; i++) {

For these patches, perhaps you can eliminate the temporary
variable and change the loop to the more common form of

	for (i = 0; i < ARRAY_SIZE(array); i++) {


