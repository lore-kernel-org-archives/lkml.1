Return-Path: <linux-kernel-owner+w=401wt.eu-S1762411AbXHGMnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762411AbXHGMnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 08:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbXHGMno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 08:43:44 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58537 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756147AbXHGMnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 08:43:43 -0400
Date: Tue, 7 Aug 2007 13:20:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: borislav@users.sourceforge.net, hmh@hmh.eng.br,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: refcounting problems with ibm_acpi but acpi=off
Message-ID: <20070807112009.GA2119@elf.ucw.cz>
References: <20070807104500.GA1684@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070807104500.GA1684@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I get this nastyness in syslog if I compile ibm_acpi into kernel, then
> boot with acpi=off.

> Perhaps this is needed?

Indeed the patch fixes it. Signed-off-by: Pavel Machek <pavel@suse.cz>

> 
> diff --git a/drivers/acpi/ibm_acpi.c b/drivers/acpi/ibm_acpi.c
> index a664f2b..654a124 100644
> --- a/drivers/acpi/ibm_acpi.c
> +++ b/drivers/acpi/ibm_acpi.c
> @@ -2695,6 +2695,9 @@ static void acpi_ibm_exit(void)
>  {
>  	int i;
>  
> +	if (acpi_disabled)
> +		return;
> +
>  	for (i = ARRAY_SIZE(ibms) - 1; i >= 0; i--)
>  		ibm_exit(&ibms[i]);
>  
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
