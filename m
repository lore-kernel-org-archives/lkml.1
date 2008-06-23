Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbYFWMRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbYFWMRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 08:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbYFWMQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 08:16:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55700 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346AbYFWMQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 08:16:46 -0400
Date: Mon, 23 Jun 2008 09:16:31 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: steve.miller@st.com, jaswinder@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpia2: use request_firmware()
Message-ID: <20080623091631.1e80a784@gaivota>
In-Reply-To: <1214219013.27974.17.camel@shinybook.infradead.org>
References: <1214219013.27974.17.camel@shinybook.infradead.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, 23 Jun 2008 12:03:33 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> diff --git a/drivers/media/video/cpia2/Kconfig b/drivers/media/video/cpia2/Kconfig
> index e39a961..64d9866 100644
> --- a/drivers/media/video/cpia2/Kconfig
> +++ b/drivers/media/video/cpia2/Kconfig
> @@ -1,9 +1,17 @@
>  config VIDEO_CPIA2
>  	tristate "CPiA2 Video For Linux"
>  	depends on VIDEO_DEV && USB && VIDEO_V4L1
> +	select FW_LOADER

Since select doesn't check for dependencies, on all places you select
FW_LOADER, you also need to add "depends on HOTPLUG" since FW_LOADER is
defined as(at drivers/base/Kconfig):

config FW_LOADER
        tristate "Userspace firmware loading support"
        depends on HOTPLUG

Cheers,
Mauro
