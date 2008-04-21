Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbYDUVvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbYDUVvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYDUVvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:51:33 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:28700 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbYDUVvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:51:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Fugi3HXYtqDNQ2iYLKVxCvPEtzIJF68ev835YTe7cVHsrERIax7S+92GSYJnJ669stW7cVDEzr0f1L/xjExJQGhRkY6OGCW93FWwaAIdwiUKfbrGiSYb2ky2UPybF7I2tKrzzA3xUMETjQmE4GTmQmKiNayGRPjvQMEOrvquqj8=
Message-ID: <1ba2fa240804211451o1c7eb062q3ae292c06ed11406@mail.gmail.com>
Date: Tue, 22 Apr 2008 00:51:28 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "SL Baur" <steve@xemacs.org>
Subject: Re: [PATCH] iwlwifi 3945 debug parameter should be writable via sysfs
Cc: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <ed10ee420804210010g228aa4b7j9383e5417b7dcb8c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ed10ee420804210010g228aa4b7j9383e5417b7dcb8c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 10:10 AM, SL Baur <steve@xemacs.org> wrote:
> Is there any reason why the debug parameter in the iwlwifi driver
>  should be read-only?
>
>  (Patch inlined and attached since I'm sure it will get whitespace
>  broken).
>
>
>  The debug parameter of the Intel 3945ABG driver should be writable
>  via sysfs.
>
>  Signed-off-by: SL Baur <steve@xemacs.org>
>  ---
>  This patch is against Linus' 2.6.25 release.
>
>  --- linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c~      2008-04-17
>  10:15:33.000000000 -0700
>  +++ linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c       2008-04-20
>  23:49:35.000000000 -0700
>  @@ -8855,7 +8855,7 @@ MODULE_PARM_DESC(disable, "manually disa
>   module_param_named(hwcrypto, iwl3945_param_hwcrypto, int, 0444);
>   MODULE_PARM_DESC(hwcrypto,
>                  "using hardware crypto engine (default 0 [software])\n");
>  -module_param_named(debug, iwl3945_param_debug, int, 0444);
>  +module_param_named(debug, iwl3945_param_debug, int, 0644);
>   MODULE_PARM_DESC(debug, "debug output mask");
>   module_param_named(disable_hw_scan, iwl3945_param_disable_hw_scan, int, 0444);
>   MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
>
>  -sb
>
it doesn't have any affect on debug output though.  This variable is
copied to to another one in pci proble
so unless you have 2 cards there is no use for it.
Run time debug output can be handled through debug_level sysfs entry
/sys/bus/pci/drivers/iwl4965/debug_level
Yet this will be changed as well to be per device instead of per driver
Tomas
