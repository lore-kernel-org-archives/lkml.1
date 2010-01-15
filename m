Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab0AOSyx (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 13:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758030Ab0AOSyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 13:54:50 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:44195 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758042Ab0AOSys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 13:54:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lVfKitCm5hXia5wT/iHyml/KsWT/Ru0knwNHrKdKh462v8+/ydL3+8gr7HeVomxSHfnU3ev/gyUALDvU1okyWNm57H7jgQBEibI10ovepS+TRD0pUV6/4fLX7vZD8Vc6;
Date: Fri, 15 Jan 2010 10:54:49 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 04/14] pci: don't dump it when bus resource flags is not
 used
Message-ID: <20100115105449.6f246f3a@jbarnes-piketon>
In-Reply-To: <1261522954-12591-5-git-send-email-yinghai@kernel.org>
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
	<1261522954-12591-5-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009 15:02:24 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> mean it is not used, so skip it.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/setup-bus.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 7d6d393..e538fa1 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -703,7 +703,8 @@ static void pci_bus_dump_res(struct pci_bus *bus)
>  
>          for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
>                  struct resource *res = bus->resource[i];
> -                if (!res || !res->end)
> +
> +		if (!res || !res->end || !res->flags)
>                          continue;
>  
>  		dev_printk(KERN_DEBUG, &bus->dev, "resource %d
> %pR\n", i, res);

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
