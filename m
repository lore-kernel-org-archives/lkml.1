Return-Path: <linux-kernel-owner+w=401wt.eu-S1764101AbXHCWvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764101AbXHCWvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 18:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760798AbXHCWve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 18:51:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44604 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759208AbXHCWvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 18:51:33 -0400
Date: Fri, 3 Aug 2007 15:50:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, riku.seppala@kymp.net,
       Andy Whitcroft <apw@shadowen.org>, Andi Kleen <ak@suse.de>
Subject: Re: Oops in 2.6.23-rc1-git9,
 arch/x86_64/pci/k8-bus.c::fill_mp_bus_to_cpumask()
Message-Id: <20070803155035.1fb11c9a.akpm@linux-foundation.org>
In-Reply-To: <46B3A7BB.9000102@redhat.com>
References: <46B3A7BB.9000102@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Aug 2007 18:10:03 -0400
Chuck Ebbert <cebbert@redhat.com> wrote:

> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=250859
> 
> at line 74:
> 
> muli@62829: 
> muli@62829: 					sd = bus->sysdata;
> muli@62829: 					sd->node = node;   <=====
> 
> bus->sysdata is NULL.
> 
> Last changed by this hunk of
> "x86-64: introduce struct pci_sysdata to facilitate sharing of ->sysdata":
> 
> @@ -67,7 +69,9 @@ fill_mp_bus_to_cpumask(void)
>  						continue;
>  					if (!node_online(node))
>  						node = 0;
> -					bus->sysdata = (void *)node;
> +
> +					sd = bus->sysdata;
> +					sd->node = node;
>  				}		
>  			}
>  		}
> 

Andy keeps trotting out a patch which will probably fix this, but for some
reason it doesn't seem to make progress.
