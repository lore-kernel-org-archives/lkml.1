Return-Path: <linux-kernel-owner+w=401wt.eu-S1759522AbZIPQJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759522AbZIPQJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759515AbZIPQJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:09:11 -0400
Received: from outbound-mail-03.bluehost.com ([69.89.21.13]:38723 "HELO
	outbound-mail-03.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759501AbZIPQJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:09:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=CgTSN8rKNGkirPg1XMCSkL+IQs26ZK9dd8Rdqn/KKvK6OnVMDun9l8/1defZ9UW6nCkGso/dyACiKmmU0HJ05hLkgs2zfiOCkFpch0ad3yIDvuzA8etdHL8/iTSCOnDK;
Date: Wed, 16 Sep 2009 09:09:07 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Michal Witkowski <neuro@o2.pl>
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>
Subject: Re: Explicitly putting a PCI device to ACPI D0
Message-ID: <20090916090907.2538fca1@jbarnes-g45>
In-Reply-To: <200909160910.24329.neuro@o2.pl>
References: <200909160910.24329.neuro@o2.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009 09:10:24 +0200
Michal Witkowski <neuro@o2.pl> wrote:

> Hi,
> 
> I've been searching for my answer for a while now, and since I
> haven't found it anywhere, I've decided to post to LKML, hoping that
> someone here can help me.
> 
> First, I'll explain the background of my problem. My grief is the
> switchable GPU in my Lenovo Ideapad U330. The BIOS supports two
> options "Discrete only" (only the ATI card is visible on the BUS) and
> "Switchable" (both ATI and Intel card visible on the bus). The
> problem is the lack of a third option "Integrated", in which only the
> Intel card would be powered off. Lenovo refused to introduce such an
> option into the BIOS, stating that it's a feature request and not a
> bug.
> 
> To save battery power I'd like to be able to run on the Intel card.
> However, with the "Switchable" option, powertop indicates huge power
> usage (24W), which can only be explained by the fact that both cards
> draw power.
> 
> Thus, my question is the following:
> Is there a way to explicitly put a device into ACPI D0? I would like
> to do that to the ATI card on boot.
> 
> I've tried the following code:
> http://ftp.chg.ru/pub/parallel/scyld/diag/pci-config.c
> But it didn't work (the ATI card was still on).

Your best bet might be to load a driver for the ATI card that puts it
into PCI D3 state until used.  There may be other ways to save power on
the disabled part as well...

Alex, is this something you've looked at at all?

-- 
Jesse Barnes, Intel Open Source Technology Center
