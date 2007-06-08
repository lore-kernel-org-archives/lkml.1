Return-Path: <linux-kernel-owner+w=401wt.eu-S939482AbXFHTf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939482AbXFHTf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbXFHTfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:35:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53851 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752970AbXFHTfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:35:12 -0400
Date: Fri, 8 Jun 2007 12:35:06 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Mike Schmidt <mike@intello.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How does dummy network driver get its mac addresses?
Message-ID: <20070608123506.3397283f@localhost.localdomain>
In-Reply-To: <4669A80E.1050102@intello.com>
References: <4669A80E.1050102@intello.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Jun 2007 15:03:42 -0400
Mike Schmidt <mike@intello.com> wrote:

> please cc me directly with any responses - I am not (yet) a member of this mailing list.
> 
> I just created 99 dummy network devices, and they all had different, random-looking addresses. I recently searched though all the IANA/IEEE documentation looking for a mechanism or policy to select local, virtual mac addresses that could not interfere with real ones. But there seems to be no clear concensus. Even the use of the 'local' bit seems to be inconsistent, I saw registered OUIs in the AA:... (from memory) range, for example. 
> 
> I noticed that all the mac addresses assigned by the dummy driver have the 'local' bit set. For those who are wondering, that's the second least significant bit  in the first digit of the mac address: so all addresses that start with x2, x3, x6, x7, xA, xB, and xE, xF are 'local'. The last bit is the multicast bit.
> 
> In the 2.4 kernels, these devices all received a 00:00:00... mac address, although this is declared incorrect in the RFCs I read. So, I was making my own, somewhat arbitrarily. In 2.6, this seems to be solved. Can anyone tell me what the algorithm/criteria are that allow the 2.6 kernels to set up random mac addresses without conflicting with real devices?


> I have searched the mailing list, but it's pretty hard to select for this kind of information. 
> 
> Thanks very much. This is a great mailing list. It's been very responsive to me so far. I thank you all. 


1. Learn to read the kernel source.  dummy gets its addresses from
   random_ether_addr()

2. Read the maintainers file, questions like this goto netdev@vger.kernel.org


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
