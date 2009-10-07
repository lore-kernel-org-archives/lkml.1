Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbZJGV4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbZJGV4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbZJGV4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:56:53 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:40392 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbZJGV4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:56:52 -0400
Message-ID: <4ACD0E5A.7060106@oracle.com>
Date: Wed, 07 Oct 2009 14:55:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: make WEXT_SPY and WEXT_PRIV select WEXT_CORE
References: <20091007105720.a2457e5b.randy.dunlap@oracle.com> <1254949672-24022-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1254949672-24022-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4ACD0E71.005B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John W. Linville wrote:
> Should prevent this build error reported by Randy...
> 
> net/wireless/wext-priv.c:206: error: implicit declaration of function 'call_commit_handler'
> make[3]: *** [net/wireless/wext-priv.o] Error 1
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Sorry, it did not work for me.

linux-next-20091007/net/wireless/wext-priv.c:206: error: implicit declaration of function 'call_commit_handler'
make[3]: *** [net/wireless/wext-priv.o] Error 1

Drivers like hostap and orinoco (hermes) select WEXT_PRIV regardless
of the setting of WEXT_CORE.  oh, and staging/ drivers do that also.


> @@ -12,9 +12,11 @@ config WEXT_PROC
>  
>  config WEXT_SPY
>  	bool
> +	depends on WEXT_CORE
>  
>  config WEXT_PRIV
>  	bool
> +	depends on WEXT_CORE
>  
>  config CFG80211
>  	tristate "cfg80211 - wireless configuration API"

