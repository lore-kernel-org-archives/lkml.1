Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbYHCLPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbYHCLPR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 07:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYHCLPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 07:15:04 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54193 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbYHCLPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 07:15:03 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48959288.4040108@s5r6.in-berlin.de>
Date: Sun, 03 Aug 2008 13:12:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Oliver Pinter <oliver.pntr@gmail.com>
CC: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
       Abdel Benamrouche <draconux@gmail.com>, stable@kernel.org,
       jens.axboe@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC, 2.6.26.2-rc1] fs/partition/check.c: fix return value warning
References: <200808022202.48079.oliver.pntr@gmail.com>	 <alpine.LFD.1.10.0808021254190.3874@nehalem.linux-foundation.org>	 <20080802200448.GH615@1wt.eu> <6101e8c40808021309r7de3cd31r11eb707b14c92fc4@mail.gmail.com>
In-Reply-To: <6101e8c40808021309r7de3cd31r11eb707b14c92fc4@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Pinter wrote:
> Willy, this good to know ...
> 
> and I think, this patch fixed a small leak:
> 
> +
> +out2:
> +       device_del(&p->dev);
> +out1:
> +       put_device(&p->dev);
> +       free_part_stats(p);
> +out0:
> +       kfree(p);
> +       return err;
> 
> 
> On 8/2/08, Willy Tarreau <w@1wt.eu> wrote:
>> On Sat, Aug 02, 2008 at 12:56:10PM -0700, Linus Torvalds wrote:
>>> Please don't just send patches to the stable team because they "look
>>> fine". They should be real bugs, with real consequences. And no, a
>>> compiler warning is not a real consequence.

Oliver, check under which circumstances the leak happens, and which 
problems the leak causes for the system.

Newly added failure handling paths, which by nature are insufficiently 
runtime-tested, need to be well considered before they are taken over 
into -stable even if the code looks OK.  I.e. they need to address bugs 
which are known to cause problems of certain severity in practice.
-- 
Stefan Richter
-=====-==--- =--- ---==
http://arcgraph.de/sr/
