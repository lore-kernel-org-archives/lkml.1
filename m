Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZICAYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZICAYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 20:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbZICAYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 20:24:19 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:61508 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbZICAYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 20:24:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MoOw8fDzLR7Obqxunm9+UAnDbNmH1lsRoRp3I1srhHDb6OC+5xism8OJcK0ZG4Lr61
         bz8NdnNMcBc0wobLw4ThHAwrSo3mrJ+plRsFB8W+YJA4n6ZMhHeU2yQ5ipxMddmR0D2S
         gIJqJvreq+Z7zuAef+h2ZGEwNAhYYYS/sgT0E=
MIME-Version: 1.0
In-Reply-To: <20090902145225.GA16359@chram.org>
References: <6661.1251822466@nice.ram.loc> <4A9DF3E9.9090309@gmail.com>
	 <20090902111927.GA4590@chram.org>
	 <51f3faa70909020742g19007084j19a0ed071aaeffdf@mail.gmail.com>
	 <20090902145225.GA16359@chram.org>
Date: Wed, 2 Sep 2009 18:24:17 -0600
Message-ID: <51f3faa70909021724v45d2902ewdb10d5f4a188f2be@mail.gmail.com>
Subject: Re: [2.6.30.5] Diagnosing an IDE lockup with SMART long tests
From: Robert Hancock <hancockrwd@gmail.com>
To: Raphael Manfredi <Raphael_Manfredi@pobox.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 2, 2009 at 8:52 AM, Raphael
Manfredi<Raphael_Manfredi@pobox.com> wrote:
> Quoting Robert Hancock:
> : Can you post what particular command you're running to run the SMART
> : test, and also the full dmesg output from bootup? Also CCing
> : linux-ide.
>
> Sure, I'm using:
>
>        smartctl -t long /dev/sda
>
> to launch the SMART test.
>
> Here's the requested dmesg output:

Is it always this drive that's failing? I see there's a second of the
same model, does it show the same behavior?

> ata1.00: ATA-6: HDS722512VLAT80, V33OA60A, max UDMA/100
> ata1.00: 241254720 sectors, multi 16: LBA48

If only that particular drive shows this problem, then I would start
to suspect a hardware fault with that drive. The fact that it fails
with both IDE and libata (and with ata_piix, which is a really
commonly used and tested libata driver) rather points in that
direction. Errors normally shouldn't lock up the machine, except that
if the drive is doing bad things with IORDY for example, it can
basically stall the machine forever and there's nothing the kernel can
do about it..
