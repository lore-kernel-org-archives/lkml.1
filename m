Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbYJAT0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbYJAT0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 15:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYJAT0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 15:26:34 -0400
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:49577 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753111AbYJAT0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 15:26:33 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] capability: WARN when invalid capability is requested 	rather than BUG/panic
To: Eric Paris <eparis@redhat.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       sds@tycho.nsa.gov, morgan@kernel.org, selinux@tycho.nsa.gov,
       Arjan van de Ven <arjan@infradead.org>
Reply-To: 7eggert@gmx.de
Date: Wed, 01 Oct 2008 21:36:39 +0200
References: <bhO5y-S0-29@gated-at.bofh.it> <bhOyr-1kZ-5@gated-at.bofh.it> <bhOyr-1kZ-3@gated-at.bofh.it> <bhPuC-2yN-5@gated-at.bofh.it> <bhPXy-3jl-13@gated-at.bofh.it> <bhQh0-3CK-9@gated-at.bofh.it> <bhRd4-4RS-9@gated-at.bofh.it> <bhRd8-4RS-27@gated-at.bofh.it> <bibY4-6WP-13@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Kl7V2-00026B-20@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@redhat.com> wrote:

> Do we have any concern of a module being compiled against a new kernel
> say with cap number 35 defined and then loaded into a kernel with only
> 34 capabilities?  Do we care about that forward compatibility?  If we
> care BUG is scary.  EPERM would be the right thing since clearly on this
> kernel the process can't possibly have cap #35.
> 
> We really have 4 options (in the order I like them).
> 
> 1) do nothing (garbage in garbage out, sometimes panic sometimes not)
> 2) mask CAP_TO_INDEX (garbage in garbage out, no panic)
> 3) BUG_ON(!cap_valid(flag)) (garbage in BUG out, no panic)
> 4) WARN_ON/EPERM (garbage in EPERM out, no panic)

5) Use a macro or inline function to test for $cap <= $max_cap, eliminating
   the test in the final code.

