Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbXFZIZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbXFZIZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 04:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbXFZIZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 04:25:05 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:60374 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbXFZIZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 04:25:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KEwXg5W5xX4gUxQBG6nqpmTkpUPefUwNxfNwgomRiDSF074RiVX8II0OEjDvKmy9EE/ElGhoWLnuzB02i5XzdAIr3g0suUEIimu4wCeTkFi0O49u+xWTmhHIf/ZNTo+lQ4eWfNlm94QW8Q8aj0fery0hxUivbngEZuY0bCUmiaU=
Message-ID: <a781481a0706260125l76c5848aq85403a4ec94d57da@mail.gmail.com>
Date: Tue, 26 Jun 2007 13:55:01 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: gshan <gshan@alcatel-lucent.com>
Subject: Re: bugs in __schedule()
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4680CC51.1050205@alcatel-lucent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4680C6F3.9000504@alcatel-lucent.com>
	 <a781481a0706260118o2ef795bj579b3ec86c4fca8a@mail.gmail.com>
	 <4680CC51.1050205@alcatel-lucent.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gavin,

On 6/26/07, gshan <gshan@alcatel-lucent.com> wrote:
> Here is the all output I have:
>
> # ifconfig mgt0 10.0.51.27
> BUG: scheduling while atomic: exe/0x00000101/752

Yup, you can't sleep in taskets, they're atomic.

> caller is schedule+0x4c/0xe4
> Call trace:
>  [c02dc4dc] __schedule+0x654/0x788
>  [c02dc6f4] schedule+0x4c/0xe4
>  [c02dbe24] __compat_down+0xc8/0x12c

So, you can't use / acquire semaphores in them. Use spinlocks.
If the shared data is also accessed from process context, use
spin_lock_bh() from the process context code.

Satyam
