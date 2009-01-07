Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109AbZAGFIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbZAGFIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 00:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbZAGFIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 00:08:13 -0500
Received: from ag-out-0708.google.com ([72.14.246.240]:12895 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbZAGFIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 00:08:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=t73Wi0z/qUuNFqkZHTmn++6c8Uvlx+M6hXGZuIeJHwGN4wbJZ/3rmvkVZtekf1ktI8
         xWl4/Q/rljuYXG0QOh6e8grZpxoUOvKWPGQ9D75qyuakEzKpGPivw/dEfG9BQ7owZ+z9
         Di3yv+bkmUFAJwdZWitzkl4jpo/jmbFcfPXgo=
Message-ID: <121039230901062108s7312343cwaf81feebfcf8d734@mail.gmail.com>
Date: Wed, 7 Jan 2009 10:38:11 +0530
From: "melwyn lobo" <linux.melwyn@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: SMP timer issue
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,
Following reply from Russell on the ARM mailing list, I have posted my
question on this list.

We have ported the arm kernel 2.6.24 to ARM Cortex dual core
processor. My question is regarding timer optimization.
At present we have three timers for the two cores as follows;
1. MTU which provides the system tick and in the absence of local
timers provides IPI_TIMER messages to other processors.
2. Localtimer for CPU0
3. Localtimer for CPU1

So presently (when local timers are enabled) there are 3 interrupts
for every tick. I want to optimize the logic performed by MTU into the
local timer of CPU0 so that this one serves as the system tick. Thus
there would be no need for MTU interrupts and it would serve only as a
clock source.

My question in particular:
1. Is there some platform which has already done this ?
2. Is this possible without modifying existing kernel framework?
3. How to update jiffies during boot when localtimer has not yet been setup?

Eagerly awaiting for some advice/comments.

Thanks & Regards,
Melwyn

On Tue, Jan 6, 2009 at 11:44 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Jan 06, 2009 at 03:07:15PM +0530, melwyn lobo wrote:
>> Hello All,
>
> I suggest you ask your question of the kernel timer folk, who would
> be more knowledgable of the code you're asking about.  See the
> MAINTAINERS file for their contact info.
>
