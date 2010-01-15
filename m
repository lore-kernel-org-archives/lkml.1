Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab0AOTM5 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 14:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758063Ab0AOTM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 14:12:56 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:44948 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757627Ab0AOTMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 14:12:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qgXv4sT7MmQvcYqbDGs5WoiOMU4WvrbFD9QcLsnDtO8wPd6yXSfNYq5/dhwIr4fWy5kOGCmKUyrqf0iQJuiaRgxfjIpHbDaHq5dS1pFb8X2luqnMExcWo1lqQQeYxKUT;
Date: Fri, 15 Jan 2010 11:12:54 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 08/14] pci: update bridge res to get more big range in
 pci assign unssign
Message-ID: <20100115111254.1f9d66a3@jbarnes-piketon>
In-Reply-To: <1261522954-12591-9-git-send-email-yinghai@kernel.org>
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
	<1261522954-12591-9-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009 15:02:28 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> BIOS separate IO range between several IOHs, and on some slots, BIOS
> assign the resource to the bridge, but stop assigning resource to the
> device under that bridge, because the device need big resource.
> 
> 1. pci assign unassign and record the failed device resource.
> 2. clear the BIOS assigned resource of the parent bridge of fail
> device 3. go back and call pci assign unsigned
> 4. if it still fail, will go up more bridges. and clear and try again.
> 
> use pci_try_num to control back track bridge levels.
> 
> -v2: update it with resource_list_x
> -v3: make pci_try_num default to 1. and when pci_try_num is set to
> more than 1 will check it with max_depth, and adjust that to make
> sure it is bigger enough

I really don't like the 'try' argument.  Either we can assign the
resource or not; 'try=' just makes the whole thing scarier, as if we
expect problems if we release too many resources.  If that's the case,
then the whole approach must be flawed, since it means we're not taking
into account some resources, or we're missing something about the
system configuration.

-- 
Jesse Barnes, Intel Open Source Technology Center
