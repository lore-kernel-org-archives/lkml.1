Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbZFJAWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbZFJAWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 20:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbZFJAWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 20:22:38 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38008 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZFJAWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 20:22:37 -0400
Date: Wed, 10 Jun 2009 01:22:36 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: linux-acpi@vger.kernel.org, dsilvers@simtec.co.uk,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] toshiba-acpi: Support TOS1900-type devices
Message-ID: <20090610002236.GA19743@srcf.ucam.org>
References: <20090331230217.GA31599@srcf.ucam.org> <74962ea30904010950u31fbdca3w51eafb9b7ec1ca73@mail.gmail.com> <20090401165345.GA13939@srcf.ucam.org> <74962ea30904011003o354e8780ya5e9ac1a6a579084@mail.gmail.com> <20090401170708.GA14167@srcf.ucam.org> <74962ea30904011013v5ffa0620y1f1aefa2c84e1ce@mail.gmail.com> <20090602140357.GA13548@srcf.ucam.org> <74962ea30906090942r43d374e7ra00e5056eca040a8@mail.gmail.com> <20090609164529.GA11592@srcf.ucam.org> <74962ea30906091718o274a0968ica61ee7a8d915ed5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74962ea30906091718o274a0968ica61ee7a8d915ed5@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 06:18:59PM -0600, Azael Avalos wrote:

> Indeed an i8042 event pops up, actually dmesg shows the following
> regardless of the hotkey pressed, even by only pressing the Fn key:
> 
> atkbd.c: Unknown key released (translated set 2, code 0x6e on isa0060/serio0).
> atkbd.c: Use 'setkeycodes 6e <keycode>' to make it known.

On press or on release? We could potentially grab that inside 
toshiba_acpi and use that to trigger the poll, but we'd still need to 
clear the value again. That's kind of ugly. The _Q43 method is clearly 
what should be being executed, so maybe there's another call we can make 
that enables it. I'll dig into your DSDT some more.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
