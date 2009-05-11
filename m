Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbZEKPi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbZEKPi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbZEKPiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:38:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:48975 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZEKPiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:38:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S0HVwG/Jn20kgK/w399SuB7A7H4mNCWGTU1ROCzEziqOIkvt1R3PBG1y2HVaFwPcSK
         Vi7ek18cq1y6P2LMklllJF/kXpOOKkb2W8jZakwnhopvXrUuO6njImpbKSv1iHlCrxqu
         uHBERq36XG2LYaOZgN3gTneaPaneqLVoF0C6M=
Date: Mon, 11 May 2009 08:38:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kwangwoo Lee <kwangwoo.lee@gmail.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
       Trilok Soni <soni.trilok@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/2] Input: tsc2007: do I2C transfers in non-interrupt
	context
Message-ID: <20090511153808.GA6973@dtor-d630.eng.vmware.com>
References: <483a38b80905110444n7d55b967j70cf2639dff1c706@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483a38b80905110444n7d55b967j70cf2639dff1c706@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 11, 2009 at 08:44:00PM +0900, Kwangwoo Lee wrote:
> From d5de0d22109de7564f9bf1df688acbe6b18f41db Mon Sep 17 00:00:00 2001
> From: Kwangwoo Lee <kwangwoo.lee@gmail.com>
> Date: Mon, 11 May 2009 20:05:50 +0900
> Subject: [PATCH 2/2] Input: tsc2007: do I2C transfers in non-interrupt context.
> 
> This patch enhances pointer movements much smoother.
> The original patch is written by Thierry.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Signed-off-by: Kwangwoo Lee <kwangwoo.lee@gmail.com>
> ---
>  drivers/input/touchscreen/tsc2007.c |   18 ++++++++++++++----
>  1 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/tsc2007.c
> b/drivers/input/touchscreen/tsc2007.c
> index 948e167..03bbe58 100644
> --- a/drivers/input/touchscreen/tsc2007.c
> +++ b/drivers/input/touchscreen/tsc2007.c
> @@ -70,6 +70,7 @@ struct ts_event {
>  struct tsc2007 {
>  	struct input_dev	*input;
>  	char			phys[32];
> +	struct work_struct	work;

Every time I see a work_struct in a driver and don't see
cancel_work_sync() anywhere I know there are issues...

-- 
Dmitry
