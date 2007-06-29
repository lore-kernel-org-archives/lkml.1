Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbXF2T4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbXF2T4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 15:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbXF2Tz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 15:55:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:41134 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbXF2Tz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 15:55:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Lc9hz5jTnVMvxOtY7IVhzEKFRRfPmSftsT9pV1D00kGoKwVuwzCpU46BPVpScm3/NadqErgNAV76sBOhrERPypJNEPeWHLYRSu4rJmLRxGDQ/tJIBVoB/zPbJgVYQGwvcmEFEFr5bWSl630WehhzKZ8DtoWEQLznUz9iHkKfuuo=
Message-ID: <6a1c323c0706291255l78d3081at2e0738a5c7cbf73b@mail.gmail.com>
Date: Fri, 29 Jun 2007 15:55:49 -0400
From: "LOL ER" <cryptococa@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Need help making sense of IRQ API
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  I've been trying to make sense of how the kernel (on an i386) calls
__do_IRQ() from do_IRQ() for the past few days to no avail. After
doing some research I found out that do_IRQ() calls the corresponding
"highlevel irq-events handler", this lead me to believe that the
kernel calls __do_IRQ through "desc->handle_irq(irq, desc);" (snippet
from do_IRQ in arch/i386). Looking at the kernel I found a comment
which reads, " * @handle_irq: highlevel irq-events handler [if NULL,
__do_IRQ()]", instinctively I then grepped through the kernel to find
any instances of where handle_IRQ is checked for being NULL. I then
found an inlined function called generic_handle_irq that does just
that. If indeed generic_handle_irq() is the default value of
handle_irq(), why is its datatype not irq_flow_handler_t, and where in
the kernel is it set as the default "highlevel irq-events handler?"
Just to clarify what I mean, the handle_irq member in the irq_desc
struct has its datatype as irq_flow_handler_t, which is a function
pointer that takes 2 arguments,  "unsigned int irq, struct irq_desc
*desc", however unsigned generic_handle_irq() takes one argument,
which is just an int representing the IRQ number.
Thank You,
   Robert G.
