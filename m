Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbXHTCYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbXHTCYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 22:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbXHTCX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 22:23:57 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:52316 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbXHTCX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 22:23:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FJHad3caR1Bddl9WyeZW0yg7HobGwPELgBlUFXJg5TrhmmkQtr2+IwESmQJa+hL9sI4xR/25UzPMkezQ4aF3Wy6T2LNnOtTHQhKt1K10lGI5oLSARzsOvG00bFTvael6LlwdeMJE7wfVzdFT6eUV8NfwGbJu+i8cUDIaVaG5ClU=
Message-ID: <34d269d40708191923i72881e7bl5ef37d2320f6ace@mail.gmail.com>
Date: Sun, 19 Aug 2007 20:23:54 -0600
From: "Alex Hunsaker" <badalex@gmail.com>
To: "Alexey Starikovskiy" <astarikovskiy@suse.de>
Subject: Re: [ACPI] Regression 2.6.23-rc3 fails to boot (acpi)
Cc: len.brown@intel.com, linux-kernel@vger.kernel.org
In-Reply-To: <46C884DF.4080101@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <34d269d40708190145m7a17ed35g190f0a5fabc4776e@mail.gmail.com>
	 <46C884DF.4080101@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/19/07, Alexey Starikovskiy <astarikovskiy@suse.de> wrote:
> What machine is it?
> Could you open a bug at bugzilla.kernel.org and append acpidump output
> to it?
>

Done, see http://bugzilla.kernel.org/show_bug.cgi?id=8909

> Thanks,
> Alex.
>
> Alex Hunsaker wrote:
> > Hangs on boot with:
> > ACPI: EC: GPE = 0x4, I/O: command/status = 0x66, data = 0x62
> > ACPI: Interpreter enabled
> > ACPI: (supports S0 S3)
> > ACPI: Using PIC for interrupt routing
> > ACIP: EC: GPE = 0x4, I/O: command/status = 0x66, data = 0x62
> >
> > 2.6.23-rc2 is ok
> > 2.6.23-rc3 bad
> > 2.6.23-rc3-latest (7c010de7506954e973abfab5c5999c5a97f7a73e) bad
> >
> > git-bisect narrowed it down to:
> >
> > 7c010de7506954e973abfab5c5999c5a97f7a73e
> > ACPI: EC: Switch from boot_ec as soon as we find its desc in DSDT.
> > Alexey Starikovskiy [Fri, 3 Aug 2007 21:57:53 +0000 (17:57 -0400)]
> > Some ASUS laptops fail to use boot time EC
> > and need to eventually switch to one described in DSDT.
> >
> > http://bugzilla.kernel.org/show_bug.cgi?id=8709
> >
> > Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
> > Signed-off-by: Len Brown <len.brown@intel.com>
> >
> > Reverting the above commit fixes the problem.
> >
>
>
