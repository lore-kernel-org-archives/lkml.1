Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbYCBReU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbYCBReU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 12:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbYCBReL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 12:34:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:13627 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbYCBReJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 12:34:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=JtIXpLMjvBNCxcLL872Dlltu1KEcxcpCcgR6rY84ujNfFqoClCBTl0o3v7lSI+Z5UnVTmh8GiJPAzk4QiXERvqQULw73qLC3TI/qAOeEm11uX38qrQzJ6Clxi0EXlP/I7F/k9cKknkmgLgPjOwSP2EdB3uV2nNnzJiXRTS31zqk=
Message-ID: <47CAE50C.2000106@gmail.com>
Date: Sun, 02 Mar 2008 20:34:04 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] saa7146: fix sparse warnings
References: <1203616356.20345.45.camel@brick>
In-Reply-To: <1203616356.20345.45.camel@brick>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison пишет:
> Went along with the existing file style.
> drivers/media/common/saa7146_core.c:309:6: warning: Using plain integer as NULL pointer
> drivers/media/common/saa7146_core.c:311:8: warning: Using plain integer as NULL pointer
> drivers/media/common/saa7146_core.c:319:7: warning: Using plain integer as NULL pointer
> drivers/media/common/saa7146_core.c:319:28: warning: Using plain integer as NULL pointer
> drivers/media/common/saa7146_core.c:325:7: warning: Using plain integer as NULL pointer
> drivers/media/common/saa7146_core.c:325:28: warning: Using plain integer as NULL pointer
> drivers/media/common/saa7146_fops.c:275:12: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/media/common/saa7146_core.c |    8 ++++----
>  drivers/media/common/saa7146_fops.c |    2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
> index 168a8d3..8c755a1 100644
> --- a/drivers/media/common/saa7146_core.c
> +++ b/drivers/media/common/saa7146_core.c
> @@ -306,9 +306,9 @@ static irqreturn_t interrupt_hw(int irq, void *dev_id)
>  		return IRQ_NONE;
>  	}
>  
> -	if( 0 != (dev->ext)) {
> +	if( NULL != (dev->ext)) {

At the risk of looking an idiot, I'm taking a liberty to ask what is
the point in explicit comparison to zero in conditional operators? Is
it not a fundamental C idiom to write

if (a) {
}

instead of

if (a != 0) {
}

and, similarly, to write

if (!a) {
}

instead of

if (a == 0) {
}

?

Thanks,

Dmitri


