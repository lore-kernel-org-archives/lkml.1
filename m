Return-Path: <linux-kernel-owner+w=401wt.eu-S1760361AbZLPUua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760361AbZLPUua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 15:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbZLPUuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 15:50:24 -0500
Received: from outbound-mail-307.bluehost.com ([67.222.53.253]:38129 "HELO
	outbound-mail-307.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752777AbZLPUuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 15:50:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=UU/Qk3bd3MtgCJMEHLPKlIOLo4wzrSSb99HS6oC3G1n/41vBbbnhAbkR48YHtPou3QqJeI6ts+KH+NaHdFHRLHMwpf90Qe9sZjx4w87BxQ3JjUWoW+o5JjdWsfPE1ZT/;
Date: Wed, 16 Dec 2009 12:50:02 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 3/9] pci: don't dump it when bus resource flags is not
 used
Message-ID: <20091216125002.07117860@jbarnes-piketon>
In-Reply-To: <4B10D2C0.60104@kernel.org>
References: <4ADEB601.8020200@kernel.org>
	<4AE5EFDB.2060908@kernel.org>
	<4AE80170.6030402@jp.fujitsu.com>
	<4AE88305.8020207@kernel.org>
	<m1ljivibrt.fsf@fess.ebiederm.org>
	<4AE899A0.3020006@kernel.org>
	<4AE95247.8080401@jp.fujitsu.com>
	<4AE952B9.1010603@kernel.org>
	<4AE9588E.90708@jp.fujitsu.com>
	<4AE9657F.7010302@kernel.org>
	<4AE965D9.9040702@kernel.org>
	<20091104093044.17ab628a@jbarnes-piketon>
	<4AF1CD79.4010602@kernel.org>
	<4AF22CF1.1020508@kernel.org>
	<4AF22D26.4070500@kernel.org>
	<4AF508F0.9060105@kernel.org>
	<4AF91F54.10507@jp.fujitsu.com>
	<4AF936DB.1030309@kernel.org>
	<4AFCF7D8.1090207@jp.fujitsu.com>
	<4AFCFC0D.4030002@kernel.org>
	<4AFD19DA.7010602@jp.fujitsu.com>
	<4AFE6F39.5080505@kernel.org>
	<4B0B321E.4010103@jp.fujitsu.com>
	<4B0B335E.1070809@kernel.org>
	<4B0B3C13.9030502@jp.fujit! su.com>
	<4B0C69AD.3030106@kernel. org>
	<4B0D13EB.9010403@jp.fujitsu.com>
	<4B10D084.8070608@kerne!
 l.org>
	<4B10D2C0.60104@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Nov 2009 23:35:28 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> 
> mean it is not used, so skip it.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/setup-bus.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -727,7 +727,8 @@ static void pci_bus_dump_res(struct pci_
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

Seems fine apart from whitespace (looks like the if (...) isn't tabbed
in properly?).

-- 
Jesse Barnes, Intel Open Source Technology Center
