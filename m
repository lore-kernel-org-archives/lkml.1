Return-Path: <linux-kernel-owner+w=401wt.eu-S1755085AbYIVXu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbYIVXu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 19:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbYIVXuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 19:50:10 -0400
Received: from sous-sol.org ([216.99.217.87]:45390 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754046AbYIVXuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 19:50:08 -0400
Date: Mon, 22 Sep 2008 15:57:33 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       James Morris <jmorris@redhat.com>, Andrew Morgan <morgan@kernel.org>,
       Andreas Gruenbacher <agruen@suse.de>, Andrew Morton <akpm@osdl.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 1/2] file capabilities: add no_file_caps switch (v2)
Message-ID: <20080922225733.GB610@sequoia.sous-sol.org>
References: <20080922184835.GA2826@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922184835.GA2826@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Serge E. Hallyn (serue@us.ibm.com) wrote:
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -33,6 +33,19 @@ EXPORT_SYMBOL(__cap_empty_set);
>  EXPORT_SYMBOL(__cap_full_set);
>  EXPORT_SYMBOL(__cap_init_eff_set);
>  
> +#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
> +int file_caps_enabled = 1;
> +
> +static int __init file_caps_disable(char *str)
> +{
> +	file_caps_enabled = 0;
> +	return 1;
> +}
> +__setup("no_file_caps", file_caps_disable);
> +#else
> +static const int file_caps_enabled = 0;
> +#endif

> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -27,6 +27,12 @@
>  #include <linux/prctl.h>
>  #include <linux/securebits.h>
>  
> +#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
> +extern int file_caps_enabled;
> +#else
> +static const int file_caps_enabled = 0;
> +#endif
> +

file_caps_enabled cut 'n paste mistake when !CONFIG_SECURITY_FILE_CAPABILITIES?

Also, plan to update Documentation/kernel-parameters.txt?

thanks,
-chris
