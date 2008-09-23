Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbYIWV1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbYIWV1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYIWV1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:27:43 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59245 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbYIWV1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:27:42 -0400
Subject: Re: [PATCH 3/4][resubmit] TPM: rcu locking
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       serue@linux.vnet.ibm.com, safford@watson.ibm.com,
       debora@linux.vnet.ibm.com
In-Reply-To: <20080923150129.0d8356e8@bike.lwn.net>
References: <cover.1222136544.git.srajiv@linux.vnet.ibm.com>
	 <1222190371-23814-3-git-send-email-srajiv@linux.vnet.ibm.com>
	 <20080923181922.GE6637@linux.vnet.ibm.com>
	 <1222201173.24276.15.camel@blackbox> <20080923150129.0d8356e8@bike.lwn.net>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 17:27:34 -0400
Message-Id: <1222205254.9218.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-23 at 15:01 -0600, Jonathan Corbet wrote:
> On Tue, 23 Sep 2008 17:19:33 -0300
> Rajiv Andrade <srajiv@linux.vnet.ibm.com> wrote:
> 
> > Protects tpm_chip_list when transversing it.
> 
> It all looks like it should work (though it might make sense to include
> <linux/rcupdate.h> and <linux/rculist.h>.  But I have to ask: do you
> really need the added complexity of RCU here?  I suspect that TPM
> devices don't come and go very often...once most of us have ripped it
> out, we tend to leave it out...:)
> 
> jon

True, the RCU locking is overkill for the current TPM code. It will be
used in the integrity-tpm-internal-interface patch to resolve the
locking issue that Christoph Helwig noted for the case when the TPM
driver is built as a module, which it shouldn't be, instead of being
built-in.

Mimi Zohar

