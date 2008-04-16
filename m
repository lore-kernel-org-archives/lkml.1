Return-Path: <linux-kernel-owner+w=401wt.eu-S932115AbYDPUxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbYDPUxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 16:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbYDPUwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 16:52:55 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:47420 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803AbYDPUwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 16:52:54 -0400
X-Sasl-enc: wQ8HY3+DPs2rRsBMX21sUmjKbtSwfdhU5dzZarCPap31 1208379173
Date: Wed, 16 Apr 2008 17:52:49 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: bfields@fieldses.org, neilb@suse.de, ibm-acpi@hmh.eng.br,
       len.brown@intel.com, kkeil@suse.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] ThinkPad ACPI: fix possible NULL pointer
	dereference
Message-ID: <20080416205248.GA3396@khazad-dum.debian.net>
References: <20080416174421.442716301@gmail.com>> <48063bc9.2533440a.1932.1fc1@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48063bc9.2533440a.1932.1fc1@mx.google.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008, Cyrill Gorcunov wrote:
> Fix potential NULL pointer dereference if kstrdup failed
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

> Index: linux-2.6.git/drivers/misc/thinkpad_acpi.c
> ===================================================================
> --- linux-2.6.git.orig/drivers/misc/thinkpad_acpi.c	2008-04-16 20:35:34.000000000 +0400
> +++ linux-2.6.git/drivers/misc/thinkpad_acpi.c	2008-04-16 20:36:38.000000000 +0400
> @@ -5826,7 +5826,7 @@ static void __init get_thinkpad_model_da
>  
>  	tp->model_str = kstrdup(dmi_get_system_info(DMI_PRODUCT_VERSION),
>  					GFP_KERNEL);
> -	if (strnicmp(tp->model_str, "ThinkPad", 8) != 0) {
> +	if (tp->model_str && strnicmp(tp->model_str, "ThinkPad", 8) != 0) {
>  		kfree(tp->model_str);
>  		tp->model_str = NULL;
>  	}
> 
> -- 

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
