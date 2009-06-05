Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbZFEThB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbZFEThB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZFETgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:36:54 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:55141 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752400AbZFETgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:36:53 -0400
Date: Fri, 5 Jun 2009 15:36:36 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Christoph Hellwig <hch@lst.de>
cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Olaf Weber <olaf@sgi.com>, mingo@elte.hu, rusty@rustcorp.com.au,
       davem@davemloft.net
Subject: Re: [this_cpu_xx 07/11] xfs_icsb_modify_counters does not need "cpu"
 variable
In-Reply-To: <20090605192206.GA23547@lst.de>
Message-ID: <alpine.DEB.1.10.0906051531090.29755@gentwo.org>
References: <20090605191819.376530498@gentwo.org> <20090605191851.584051004@gentwo.org> <20090605192206.GA23547@lst.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009, Christoph Hellwig wrote:

> Looks good to me.  While you're at it you might also remove the
> superflous cast of the this_cpu_ptr return value.

Ok.

> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> Btw, any reason this_cpu_ptr doesn't do the preempt_disable itself
> and has something paired to reverse it?

Would break the symmetry with the atomic per cpu ops introduced in the
same patch. Putting preempt side effects and RMWs together is making
things a bit complicated.

Also if the caller manages the preempt explicity (like this piece of code)
then may be better to have separate statements for clarity.



