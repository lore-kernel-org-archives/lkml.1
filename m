Return-Path: <linux-kernel-owner+w=401wt.eu-S1752926AbYDHGNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbYDHGNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 02:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbYDHGNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 02:13:33 -0400
Received: from relay.gothnet.se ([82.193.160.251]:4744 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751170AbYDHGNc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 02:13:32 -0400
Message-ID: <47FB0CDB.1090009@tungstengraphics.com>
Date: Tue, 08 Apr 2008 08:12:43 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080306)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Andi Kleen <andi@firstfloor.org>,
       Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <200804071123.27411.jbarnes@virtuousgeek.org> <47FA7B58.6040907@tungstengraphics.com> <200804071259.19743.jbarnes@virtuousgeek.org> <47FA8826.2060802@tungstengraphics.com> <47FA8AB4.7060605@linux.intel.com>
In-Reply-To: <47FA8AB4.7060605@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Thomas Hellström wrote:
>> Ouch, so we'll be needing an ioremap_wc(), I guess. We probably 
>> shouldn't use the linear kernel map for this anyway, since that would 
>> require a chipset flush for each ring commit.  We can actually use 
>> vmap() with a wc page protection for that, but an ioremap_wc() would 
>> certainly save us a lot of trouble.
>
> please don't use vmap() as a hack for mapping IO memory when you 
> should use ioremap_wc()....
I think you've misinterpreted. We must use vmap() if we need to map the 
cpu side of the aperture, (real pages) and ioremap() if we map the 
device side, which is io memory. Some devices accept both, but what I 
was saying was we should try to avoid the vmap() alternative, since it, 
like using the kernel mapping directly, requires a chipset flush after 
update.
> Lets get this thing right rather than finding whichever hack of the day
> happens to work with the implementation from yesterday.
/Thomas



