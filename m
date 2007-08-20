Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbXHTDL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbXHTDL7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 23:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbXHTDLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 23:11:49 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:36470 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbXHTDLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 23:11:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ebXVp5pzO5ig28NynvB/mNExd7KM9YAExJTR2SPubZeV3uW3aqdi3XpQSAIAq2SFqcAFU+B4D6nX0ABV3nLeRR98Coa26GBx4OA1umvyCuVRCa4ZLLD/RmjrVuVIOkcf/DMW9QF/SQtTlxWdoPa/f9qFpKTVpGlm+2bGIDxAgaM=
Message-ID: <8bd0f97a0708192011m1b957e57je313850a255dcac7@mail.gmail.com>
Date: Sun, 19 Aug 2007 23:11:47 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: [PATCH 1/1] ensure we don't use bootconsoles after init has been released
Cc: "Andrew Morton" <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Gerd Hoffmann" <kraxel@redhat.com>
In-Reply-To: <200708192246.05783.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708192246.05783.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/19/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> +static int __init disable_boot_consoles(void)
> +{
> +       struct console *con;
> +
> +       for (con = console_drivers; con; con = con->next) {
> +               if (con->flags & CON_BOOT) {
> +                       printk(KERN_INFO "Turn off boot console %s%d\n",
> +                               con->name, con->index);
> +                       unregister_console(con);
> +               }
> +       }
> +}

erp, no 'return 0;' ... that'll earn you a warning at build time and
maybe random failures depending on the arch ...
-mike
