Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbZKPPCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbZKPPCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 10:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZKPPCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 10:02:22 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:45945 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752705AbZKPPCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 10:02:21 -0500
X-Sasl-enc: FGqLZwzzsx0qLofFRc1w/jszEwWtHLWW8DzOuzDLlgFf 1258383747
Date: Mon, 16 Nov 2009 13:02:24 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>
Cc: linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH v5 12/12] tree-wide: convert open calls to remove
	spaces to skip_spaces() lib function
Message-ID: <20091116150224.GA22176@khazad-dum.debian.net>
References: <cover.1258181836.git.andre.goddard@gmail.com> <623fc6c1c58b8c3ccf4a1373e94aba3639a0714e.1258181837.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <623fc6c1c58b8c3ccf4a1373e94aba3639a0714e.1258181837.git.andre.goddard@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
> index d93108d..e8026d9 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -1006,11 +1006,8 @@ static int parse_strtoul(const char *buf,
>  {
>  	char *endp;
>  
> -	while (*buf && isspace(*buf))
> -		buf++;
> -	*value = simple_strtoul(buf, &endp, 0);
> -	while (*endp && isspace(*endp))
> -		endp++;
> +	*value = simple_strtoul(skip_spaces(buf), &endp, 0);
> +	endp = skip_spaces(endp);
>  	if (*endp || *value > max)
>  		return -EINVAL;
>  

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
(thinkpad-acpi changes only)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
