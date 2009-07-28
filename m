Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZG1SYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZG1SYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbZG1SYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:24:36 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:37214 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbZG1SYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:24:35 -0400
X-Greylist: delayed 1911 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jul 2009 14:24:34 EDT
Message-ID: <4A6F3AEA.7090102@grupopie.com>
Date: Tue, 28 Jul 2009 18:52:42 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: jwoithe@physics.adelaide.edu.au, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 6/12] drivers/platform/x86: Correct redundant test
References: <Pine.LNX.4.64.0907271813490.2682@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0907271813490.2682@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> [...]
> ---
>  drivers/platform/x86/fujitsu-laptop.c          |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
> index 218b9a1..5306901 100644
> --- a/drivers/platform/x86/fujitsu-laptop.c
> +++ b/drivers/platform/x86/fujitsu-laptop.c
> @@ -745,9 +745,6 @@ static int acpi_fujitsu_remove(struct acpi_device *device, int type)
>  
>  	fujitsu = acpi_driver_data(device);
>  
> -	if (!device || !acpi_driver_data(device))
> -		return -EINVAL;
> -

Shouldn't this still do a:

   if (!fujitsu)
     return -EINVAL;

to avoid dereferencing a NULL pointer below?

>  	fujitsu->acpi_handle = NULL;
>  
>  	return 0;

-- 
Paulo Marques - www.grupopie.com

"All I ask is a chance to prove that money can't make me happy."
