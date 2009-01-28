Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbZA1W0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbZA1W0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbZA1WZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:25:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39321 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082AbZA1WZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:25:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH] dmi: Fix build breakage
Date: Wed, 28 Jan 2009 23:24:59 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@osdl.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1233122840-24142-1-git-send-email-galak@kernel.crashing.org>
In-Reply-To: <1233122840-24142-1-git-send-email-galak@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901282325.00215.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2009, Kumar Gala wrote:
> The following commit introduced:
> 
> commit d7b1956fed33d30c4815e848fd7a143722916868
> Author: Rafael J. Wysocki <rjw@sisk.pl>
> Date:   Mon Jan 19 20:55:50 2009 +0100
> 
>     DMI: Introduce dmi_first_match to make the interface more flexible
> 
> compile errors like the following when !CONFIG_DMI
> 
>     drivers/ata/sata_sil.c: In function 'sil_broken_system_poweroff':
>     drivers/ata/sata_sil.c:713: error: implicit declaration of function 'dmi_first_match'
>     drivers/ata/sata_sil.c:713: warning: initialization makes pointer from integer without a cast
> 
> We just need a dummy version of dmi_first_match() to fix this all up.

Well, my bad.  Thanks for the fix!

> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
> 
> This should supercede the driver specific patches I posted earlier.
> 
> - k
> 
>  include/linux/dmi.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/dmi.h b/include/linux/dmi.h
> index aea2310..d741b9c 100644
> --- a/include/linux/dmi.h
> +++ b/include/linux/dmi.h
> @@ -65,6 +65,8 @@ static inline int dmi_walk(void (*decode)(const struct dmi_header *))
>  	{ return -1; }
>  static inline bool dmi_match(enum dmi_field f, const char *str)
>  	{ return false; }
> +static inline const struct dmi_system_id *
> +	dmi_first_match(const struct dmi_system_id *list) { return NULL; }
>  
>  #endif
>  

Rafael
