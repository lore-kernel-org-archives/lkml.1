Return-Path: <linux-kernel-owner+w=401wt.eu-S1757684AbYBRHe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbYBRHe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 02:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbYBRHer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 02:34:47 -0500
Received: from mail.southpole.se ([193.12.106.18]:33823 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbYBRHeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 02:34:46 -0500
Message-ID: <47B93512.6000107@southpole.se>
Date: Mon, 18 Feb 2008 08:34:42 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071229)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, olof@lixom.net, sam@ravnborg.com
Subject: Re: [PATCH] Add PCI_DEVICE_TABLE macro
References: <1203250205-5103-1-git-send-email-jonas@southpole.se> <1203250404.24325.1.camel@satguru> <20080218044834.GB14184@kroah.com>
In-Reply-To: <20080218044834.GB14184@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> And again, what does this buy us?
> 

Clarity and simplicity, I hope... there are a bunch of definitions 
scattered about the kernel that omit the __devinitdata modifier despite 
the documentation stating that it should always be there.  The 
definition really should have been const, which wasn't possible before 
but has become so with the addition of the __devinitconst attribute.

Furthermore, there are definitions that use "const" and __devinitdata, 
which is explicitly wrong but the compiler doesn't catch section 
mismatches if there's only one such one case in the module (which is 
often the case).

Adding the __devinitconst modifier where there was nothing before buys 
us memory.  Adding the const modifier gives the compiler a chance to do 
its thing.  Changing __devinitdata to __devinitconst where it was wrong 
actually fixes some compiler errors in older (mid-release) kernels that 
were patched over by "removing" the section attribute altogether (which 
wastes memory).

Adding the macro (Olof's idea, not mine) makes it pretty difficult to 
get this definition wrong... I'll do the rest of the cleanup, but I need 
to know whether it's better to use a macro like this, or to open code 
the definitions.  I prefer the macro approach...

Hope this makes some sense...

/Jonas

