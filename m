Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913Ab0AaOLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab0AaOLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 09:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811Ab0AaOLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 09:11:24 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53659 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab0AaOLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 09:11:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=E0I2x3nlCHixH/USwM6Hy4fy8caDJn9ZWiR8LLeG+dFMBy2agFqlYWvrMsxAknQQlW
         y1ra7ghClnDfBAf1lc0fCD+KH6KU5YAfPj2essE+PtPBNwhsuNB2LmpOFq5jHl+AWoJP
         vAlTTraXLhutuSK8lxoHGfzrLxn7Pekr064hc=
MIME-Version: 1.0
In-Reply-To: <201001310029.48717.rjw@sisk.pl>
References: <201001310029.48717.rjw@sisk.pl>
Date: Sun, 31 Jan 2010 14:11:21 +0000
Message-ID: <9b2b86521001310611m339862afw73410dc7eb5692c8@mail.gmail.com>
Subject: Re: [RFC][RFT][PATCH] ACPI: Protection from suspending in the middle 
	of EC transaction
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <lenb@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/30/10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi,
>
> While Maxim is testing if the patch below helps with
> http://bugzilla.kernel.org/show_bug.cgi?id=14668
> I think it's necessary anyway.
>
> The problem is that currently there's nothing to prevent us from suspending
> in
> the middle of an EC transaction in progress, at least as far as I can see.
> As a result, we can suspend with the ACPI global lock held or something like
> this, which leads to problems especially for hibernation (if the resume
> kernel
> passes control to the image kernel in the middle of an EC transaction,
> things
> aren't nice).  For this reason I think we should wait until there are no EC
> transactions in progress before we suspend and we should prevent any new
> EC transactions from starting after that point.  The patch below does that.

I also believe this is a problem.  I reported the following -

<http://bugzilla.kernel.org/show_bug.cgi?id=14112> "Pressing acpi
hotkeys duing hibernation may occasionally cause EC transaction
timeout"

and posted a patch, but I couldn't reproduce my specific issue in
order to confirm that the patch helped.

Regards
Alan
