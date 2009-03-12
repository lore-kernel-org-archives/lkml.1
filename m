Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbZCLRrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbZCLRrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 13:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZCLRqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 13:46:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50868 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbZCLRqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 13:46:50 -0400
Date: Thu, 12 Mar 2009 18:46:42 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: linux-kernel@vger.kernel.org, ivecera@redhat.com, jgarzik@pobox.com,
       davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] 8139cp: allow to set mac address on running device
Message-ID: <20090312174641.GC20153@psychotron.englab.brq.redhat.com>
References: <20090312162730.GA20153@psychotron.englab.brq.redhat.com> <20090312181121.79e297a2@brian.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312181121.79e297a2@brian.englab.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thu, Mar 12, 2009 at 06:11:21PM CET, mschmidt@redhat.com wrote:
>On Thu, 12 Mar 2009 17:27:31 +0100
>Jiri Pirko <jpirko@redhat.com> wrote:
>
>> +	cpw32_f(MAC0 + 0, le32_to_cpu (*(__le32 *) (dev->dev_addr +
>> 0)));
>> +	cpw32_f(MAC0 + 4, le32_to_cpu (*(__le32 *) (dev->dev_addr +
>> 4)));
>
>You're writing to the card, so using *_to_cpu looks suspicious.
Well, I'm using the same approach as it is already done in function
cp_init_hw(). Quote:

 /* Restore our idea of the MAC address. */
 cpw32_f (MAC0 + 0, le32_to_cpu (*(__le32 *) (dev->dev_addr + 0)));
 cpw32_f (MAC0 + 4, le32_to_cpu (*(__le32 *) (dev->dev_addr + 4)));

Jirka
>
>Michal
