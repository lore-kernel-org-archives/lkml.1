Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbYLARum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbYLARum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 12:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYLARua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 12:50:30 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1974 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751708AbYLARu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 12:50:29 -0500
Message-ID: <493423D7.5030203@myri.com>
Date: Mon, 01 Dec 2008 12:50:15 -0500
From: Andrew Gallatin <gallatin@myri.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Jan-Bernd Themann <ossthema@de.ibm.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, tklein@de.ibm.com,
       Christoph Raisch <raisch@de.ibm.com>, jb.billaud@gmail.com,
       hering2@de.ibm.com
Subject: Re: [PATCH] lro: IP fragment checking
References: <4933A74F.3050809@de.ibm.com>
In-Reply-To: <4933A74F.3050809@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Bernd Themann wrote:
> This patch prevents that ip fragmented TCP packets are considered vaild
> for aggregation

<...>

> +	if (iph->frag_off & IP_MF)
> +		return -1;
> +

I think there is an endian bug, and that you should also check
IP_OFFSET.  What about:

	if (iph->frag_off & htons(IP_MF|IP_OFFSET))

As to whether or not to do it in the drivers/hardware or in the
LRO code, I favor doing it in the LRO code just so that it is not
missed in some driver.

Drew
