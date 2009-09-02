Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbZIBLbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbZIBLbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 07:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbZIBLbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 07:31:48 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:2784 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbZIBLbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 07:31:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D/wuEKUtaIdgWFoxrWsp5qxZ1ZbYurASPTWvKlr04DPR2ne73VceQA/4NsM+Lab5ZJ
         Ri58iLc7dO33980WDyIqD2nlLlzk9OG11CP6dPG0Y5mgU1ol1QbcVbCiEXgc+3lsO2AK
         Rpx4WC4kwuJpJn8gUxXUQZ7VUm1LL9rj4eMKA=
Date: Wed, 2 Sep 2009 15:31:44 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dac960: switch to seq_file
Message-ID: <20090902113144.GB8429@x200.localdomain>
References: <20090828195814.GE15123@x200.localdomain> <20090901162735.d30cee12.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901162735.d30cee12.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 04:27:35PM -0700, Andrew Morton wrote:
> On Fri, 28 Aug 2009 23:58:14 +0400
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> >  drivers/block/DAC960.c |  156 ++++++++++++++++++++++---------------------------
> 
> hm, that's a large change to a hard-to-change driver.
> 
> Is it correct?

Nobody knows :-)

In fact I'm pretty sure conversion is correct:
0) ->data is passed as m->private,
1) DAC960_ProcReadStatus() -- print "OK" or "ALERT" if one controller is in alert mode,
2) DAC960_ProcReadInitialStatus() -- print ->CombinedStatusBuffer content, lenght is in ->CurrentStatusLength
3) DAC960_ProcReadUserCommand() -- (2) applied to ->UserStatusBuffer

	"%.*s" does exactly that.

4) DAC960_ProcWriteUserCommand() -- signature change to ->write method, controller is in PDE(...)->data
