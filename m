Return-Path: <linux-kernel-owner+w=401wt.eu-S1762024AbXHAKaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762024AbXHAKaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 06:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbXHAKaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 06:30:13 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:9597 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbXHAKaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 06:30:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hW4VAUYLLtUZsRxI1C8fDjFRE7K4rJ4yd+voWindZdd6K/c42q9jfSjw+Suz7e+7IMnHALCmKRtSEHYDZ+2e8DG8PqaLpZuXR/NOXztvvxNgDikukwusRcqlsMh1Nqyc+SJH9MtI/uMgrf4ru8VHMGOEXEnJCqR+/rp3Q8tIZNc=
Message-ID: <46B060AD.6040907@gmail.com>
Date: Wed, 01 Aug 2007 19:30:05 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Gabriel C <nix.or.die@googlemail.com>, "A. Kalten" <akalten@comcast.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can't unload uhci_hcd module with 2.6.22 -- also oops
References: <Pine.LNX.4.44L0.0707311139120.3520-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707311139120.3520-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

Alan Stern wrote:
> Tejun:
> 
> Can you look at this oops message please?  It appears similar to the
> sysfs bug in 2.6.23-rc1, but it occurred under 2.6.22.  Is a similar 
> fix needed for the 2.6.22-stable series?

2.6.23-rc1 bug was one too many put during symlink creation failure path
leading to premature release of parent kobject on removal.  The posted
log looks more like premature module unload.

For example, something like...

1. module b uses services of module a
2. module b creates some attributes with struct attribute in the module
3. module b unloads but attr created in #2 is not removed
4. module a tries to unload and tries to remove attr from #2 and oops
because struct attribute referenced by the attr is already gone.

Thanks.

-- 
tejun
