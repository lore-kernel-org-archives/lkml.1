Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbXI3NhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbXI3NhO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 09:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbXI3NhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 09:37:03 -0400
Received: from smtprelay11.ispgateway.de ([80.67.29.28]:50715 "EHLO
	smtprelay11.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476AbXI3NhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 09:37:00 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC] Extending kbuild syntax
Date: Sun, 30 Sep 2007 15:36:55 +0200
User-Agent: KMail/1.9.6
Cc: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070929201145.GA20377@uranus.ravnborg.org>
In-Reply-To: <20070929201145.GA20377@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709301536.57156.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On Saturday 29 September 2007, Sam Ravnborg wrote:
> Introducing the following new variable could make this a oneliner:
> ccflags-y
> 
> ccflags-$(DEBUG) := -DDEBUG
> 
> grep -r -C 1 -B 1 EXTRA_CFLAGS shows that the above is a 
> very common pattern especially in drivers/

ACK. Also ACK for asflags, if done the same way :-)

> The second is the more controversial suggestion.

Yes, but please bear in mind, what the developers are trying
to express in these cases.

> In several Makefile we have simple if expression of the variants:
> if ($(CONFIG_FOO),y)
>   obj-$(CONFIG_BAR) += fubar.o
> endif

This is "feature FOO of module BAR" where the feature itself
cannot be a module. The composition scheme described in 
section 3.3 is at least equally useful. And that is used today.
Maybe the documentation of that scheme is not prominent enough :-)

> obj-y-ifn-

This is the only one needed, because it is cumbersome to express
negative rules in kbuild to include stubs (e.g. nommu stuff). 
But again this can be done with composition rules right now, but
is order dependent. If we could get rid of this requirement,
I would be happy already. So kbuild is just lacking an "else" 
clause here.


Best Regards

Ingo Oeser
