Return-Path: <linux-kernel-owner+w=401wt.eu-S1760694AbXGXNWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760694AbXGXNWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 09:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbXGXNWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 09:22:34 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:56584 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbXGXNWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 09:22:33 -0400
Message-ID: <46A5F91B.50403@hp.com>
Date: Tue, 24 Jul 2007 09:05:31 -0400
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Adrian Bunk <bunk@stusta.de>, lksctp-developers@lists.sourceforge.net,
       Gabriel C <nix.or.die@googlemail.com>,
       "Nelson, Shannon" <shannon.nelson@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Lksctp-developers] __unsafe() usage
References: <46A3FE3E.20300@googlemail.com>	<BAE9DCEF64577A439B3A37F36F9B691C02B820A3@orsmsx418.amr.corp.intel.com>	<20070723175927.GM26212@stusta.de> <1185232601.1803.41.camel@localhost.localdomain>
In-Reply-To: <1185232601.1803.41.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>  
[... snip ...]

> diff -r d7af727512fd net/sctp/protocol.c
> --- a/net/sctp/protocol.c	Tue Jul 24 08:30:05 2007 +1000
> +++ b/net/sctp/protocol.c	Tue Jul 24 09:12:43 2007 +1000
> @@ -1176,7 +1176,6 @@ SCTP_STATIC __init int sctp_init(void)
>  	if (status)
>  		goto err_v6_add_protocol;
>  
> -	__unsafe(THIS_MODULE);
>  	status = 0;
>  out:
>  	return status;
> @@ -1216,6 +1215,7 @@ err_chunk_cachep:
>  	goto out;
>  }
>  
> +#if 0
>  /* Exit handler for the SCTP protocol.  */
>  SCTP_STATIC __exit void sctp_exit(void)
>  {
> @@ -1263,9 +1263,10 @@ SCTP_STATIC __exit void sctp_exit(void)
>  
>  	proto_unregister(&sctp_prot);
>  }
> +module_exit(sctp_exit);
> +#endif
>  
>  module_init(sctp_init);
> -module_exit(sctp_exit);
>  

Please don't remove module_exit point for SCTP.  Simply removing the __unsafe() call will
be sufficient.

The code has recently been cleaned up to allow safe unloading and I working on final
cleanups.  It currently works correctly with forced unloading.

Thanks

-vlad

