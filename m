Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab0CAQeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:34:18 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:59468 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751071Ab0CAQeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:34:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=JGEt18gFwChDYR3c6UDegy5LVAxrCH0vhRryGdlJfZPlaMxiDoqo+za9JFLd3ArVTEYTPw5uok4JfwDFL4HS7Pib7ygYl+LHQSmO8KTj9f12alSqF7PP+Ue6aj3XD7xr;
Date: Mon, 1 Mar 2010 08:35:13 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] PCI changes for 2.6.34  - pci rom rom fail list
Message-ID: <20100301083513.2e77a214@jbarnes-piketon>
In-Reply-To: <alpine.LFD.2.00.1003010803360.3616@localhost.localdomain>
References: <20100226093957.7b99d09c@jbarnes-piketon>
	<alpine.LFD.2.00.1002281227300.3851@localhost.localdomain>
	<alpine.LFD.2.00.1002281246120.3637@localhost.localdomain>
	<33223F6C-10BD-4671-937D-6D5E4956DD3F@kernel.org>
	<alpine.LFD.2.00.1002281314110.3637@localhost.localdomain>
	<4B8AF121.2060106@kernel.org>
	<4B8B0113.1020103@kernel.org>
	<alpine.LFD.2.00.1003010803360.3616@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Mar 2010 08:05:55 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sun, 28 Feb 2010, Yinghai Lu wrote:
> > 
> > [PATCH] pci: don't reassign to ROM res if it is not going to be
> > enabled
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> Yes, this makes my setup work again.
> 
> I'm still nervous that it will cause problem on some _other_ machines 
> (because of not knowing that some bridge is transparent and then
> trying to re-allocate things unnecessarily and causing chaos), but at
> least it seems to be ok on this machine.
> 
> So I do have this nagging feeling that we'll still end up having to
> do this whole "reassign PCI buses" thing as a kernel command line
> option and default to not doing it, but let's give it a chance.

Yeah we went back and forth on that a bit.  We can fall back to a
command line option if necessary, but I think it would be ashame;
ideally things should just work and not require users to pass special
options when their drivers fail to bind.

-- 
Jesse Barnes, Intel Open Source Technology Center
