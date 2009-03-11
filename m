Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbZCKROR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbZCKROR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZCKROD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:14:03 -0400
Received: from main.gmane.org ([80.91.229.2]:41546 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbZCKROB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:14:01 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitriy =?utf-8?b?VlwnanVrb3Y=?= <dvyukov@gmail.com>
Subject: Re: SRCU: Number of outstanding callbacks
Date: Wed, 11 Mar 2009 17:13:47 +0000 (UTC)
Message-ID: <loom.20090311T151357-544@post.gmane.org>
References: <loom.20090311T104615-980@post.gmane.org> <20090311144327.GA7086@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 209.3.12.206 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck <at> linux.vnet.ibm.com> writes:

> The short answer is, as you guessed, because it is not (yet) worth doing.
> This is at least in part because SRCU is not heavily used.
> 
> The philosophy behind the limitation is that the memory overhead of
> the blocks is a small fraction of the memory required to represent
> a thread.  As you say, there are a number of other strategies that can
> be pursued, but the current strategy has the advantage of simplicity.
> In particular, the current strategy does not require a failure return
> from an as-yet-nonexistent call_srcu().  Handling such a failure return
> is certainly possible, but someone would have to show me an extremely
> good reason for putting up with this.  


Yes, I've noticed the extreme simplicity of the current synchronize_srcu().
As for failure return from call_srcu(), I think it's possible to just call
synchronize_srcu() from inside call_srcu() if the latter encounters any errors.
Anyway call_srcu() will be "sometimes blocking" because of the limit on number
of outstanding callbacks, so this must not be a problem.


--
Best regards,
Dmitriy V'jukov

