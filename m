Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab0BCTLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:11:31 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:41027 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab0BCTL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:11:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i2c+Q0piBScBholaz5SzuXlklaaIAivlXqpSAPs5GMaRvJbFlGObas6pf5dKFvAMEz
         9wQdG+okvdbpqy9j8NJEoRr8JNwHO84Lcy/3pKpvk0iTwhA8WZmatzWPw/92wfXA5XyE
         WzyRnNZYwyymwkE5SgiqekKq+mojoedEZNwUk=
Date: Wed, 3 Feb 2010 11:11:12 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-input@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Input: serio - re-add thaw (and add freeze)
Message-ID: <20100203191112.GC30600@core.coreip.homeip.net>
References: <4B69C7AA.7000904@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B69C7AA.7000904@tuffmail.co.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 06:59:54PM +0000, Alan Jenkins wrote:
> 633aae2 "Input: i8042 - switch to using dev_pm_ops"
> removed handling for PMSG_THAW, causing obscure breakage.
> 
> It can break if you press keys during hibernation,
> which causes subsequent keypresses to be lost -
> so you can't cancel s2disk by pressing backspace -
> and then just before system poweroff you get
> "psmouse.c: Failed to deactivate mouse".
> 
> So let's add the thaw handler back.
> 
> Also set the freeze handler.  It looks like PMSG_FREEZE
> didn't do anything in the past, but I think that must
> have been an oversight.

We do not need to do anything special at freeze time that is why there
wasn't freeze handler. And so thaw should be pretty much noop as well.

What supports canceling s2disk by backspace? I need more data to figure
out what is going on. At the moment input should be fully-functional
until poweroff.

-- 
Dmitry
