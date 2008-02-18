Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbYBRRCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbYBRRCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 12:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYBRRCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 12:02:39 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:61699 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbYBRRCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 12:02:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CHFPZWHp/gPdIXlCF7d0SM1Ih9VgzGhm21o9J+iWUDnsvJIjoqsjXrfcPOSS3tnD3HR1Q8cmD0hCL4sCaFYK45KO2ixPUZn/1fbMPBaJSPCZTFhH5uuA/VSzROW1AucZX9iYoalPZby08xfz6ql1eSTdcGDImOh+OiQL6DAPh0w=
Message-ID: <58cb370e0802180902i1c66713dmeb7f52dc444947f5@mail.gmail.com>
Date: Mon, 18 Feb 2008 18:02:36 +0100
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 1/5] ide: remove PIO "downgrade" quirk
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <47B9AD1D.4020307@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080217185105.16210.26582.sendpatchset@localhost.localdomain>
	 <47B9AD1D.4020307@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

On Feb 18, 2008 5:06 PM, Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:
> Bartlomiej Zolnierkiewicz wrote:
>
> > No need for it nowadays
>
>     Since which moment, could you elaborate

We fixed:

- PIO auto-tuning in core code

- PIO programming in host drivers

- IORDY handling in core code and in host drivers (it could be that the
  incorrect IORDY handling was the main reason behind the "downgrade")

and

- lack of corresponding "quirk" in libata hasn't been problematic so far

so IMO there is no longer a valid reason to punish PIO performance
and the said "quirk" should be removed (in 2.6.26 after long time in -mm).

> > so remove quirk code from ide_get_best_pio_mode()
> > and IDE_HFLAG_PIO_DOWNGRADE host flag.
>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
