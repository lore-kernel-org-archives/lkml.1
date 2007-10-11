Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbXJLDEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbXJLDEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 23:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbXJLDDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 23:03:51 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:21979 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755767AbXJLDDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 23:03:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0asSqmPxm882oYJF84CaPJhoev3rFizNAwjfi5fMQoAdzv4rbeUB3oNlgYOuqVBx0T8oF+ET2RVYbNiisWSt+5rVFPV3Ltre+miDPNM+aF5sjRjCoqBjNwAA5DTkKRFLLYxcQdPaJ3IpZTIrTQ0zVnrh6que6+WziC73hLnoK4g=  ;
X-YMail-OSG: C8wNqPYVM1mpiIYLh0847uMV6LjoWR63lhWex26VU4z8T.7AwRnjLrQCsEBg6kkDXtw4zWB2gw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Mr. Berkley Shands" <bshands@exegy.com>,
       Ayaz Abdulla <aabdulla@nvidia.com>, linux-netdev@vger.kernel.org
Subject: Re: 2.6.23 spinlock hang in kswapd under heavy disk write loads
Date: Thu, 11 Oct 2007 20:32:07 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <470E4E02.4000504@exegy.com>
In-Reply-To: <470E4E02.4000504@exegy.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710112032.07717.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 October 2007 02:23, Mr. Berkley Shands wrote:
> With DEBUG_SLAB on, I can run only a very short time under 2.6.23
> before a kernel panic.
>
> [  626.028180] eth0: too many iterations (6) in nv_nic_irq.
> [  626.167583] eth0: too many iterations (6) in nv_nic_irq.
> [  626.206729] eth0: too many iterations (6) in nv_nic_irq.
> [  626.400171] eth0: too many iterations (6) in nv_nic_irq.
> [  626.446374] eth0: too many iterations (6) in nv_nic_irq.
>
> followed by the crash at
> forcedeth:nv_nic_irq_optimized+0x89
> handle_IRQ_event+0x25
> handle_edge_IRQ+0xe3
> do_IRQ

OK, thanks. Probably we should try to fix this problem before
attempting the more elusive looking corruption.

CC'ed forcedeth maintainer and netdev.

Can you reiterate what your hardware is (including lspci)?
