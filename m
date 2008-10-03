Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbYJCMVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbYJCMVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 08:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbYJCMVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 08:21:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:58753 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbYJCMVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 08:21:17 -0400
Subject: Re: [RFC/PATCH] Block device for the ISS simulator
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <20081003120305.GA2229@yoda.jdub.homelinux.org>
References: <20081003000904.0A812DDEEE@ozlabs.org>
	 <20081003120305.GA2229@yoda.jdub.homelinux.org>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 22:21:04 +1000
Message-Id: <1223036464.12264.183.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-03 at 08:03 -0400, Josh Boyer wrote:
> On Fri, Oct 03, 2008 at 10:08:42AM +1000, Benjamin Herrenschmidt wrote:
> >+static void iss_blk_setup(struct iss_blk *ib)
> >+{
> >+	unsigned long flags;
> >+	u32 stat;
> >+
> >+	pr_debug("iss_blk_setup %d\n", ib->devno);
> >+
> >+	spin_lock_irqsave(&iss_blk_reglock, flags);
> >+	out_8(iss_blk_regs->data, 0);
> >+	out_be32(&iss_blk_regs->devno, ib->devno);
> >+	out_8(&iss_blk_regs->cmd, ISS_BD_CMD_OPEN);
> >+	stat = in_be32(&iss_blk_regs->stat);
> 
> Should probably use the ioread/iowrite functions instead of raw out/in.
> Same comment throughout.

Yeah well, old habits :-)

> >+		pr_debug(" -> ending request, rc = %d\n", rc);
> >+		if (rc)
> >+			end_request(req, 0);	/* failure */
> >+		else
> >+			end_request(req, 1);	/* success */
> 
> Could possibly just do:
> 
> end_request(req, (!rc));

I knew copy/pasting from a crap driver was going to come back and bite
me :)

> of_find_node_by_path increments the refcount for that node.  Need to
> do an of_node_put when you are done.

Yup, suppose so.

> Shouldn't you unmap iss_blk_regs at this point?

Might be a good idea yeah.

Ben.


