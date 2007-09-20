Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbXITV6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbXITV6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbXITV6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:58:20 -0400
Received: from neon.samage.net ([85.17.153.66]:57608 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440AbXITV6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:58:19 -0400
X-Greylist: delayed 1890 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Sep 2007 17:58:19 EDT
Message-ID: <59465.81.207.0.53.1190323573.squirrel@secure.samage.net>
In-Reply-To: <200709201538.43093.rob@landley.net>
References: <46F1645D.9050406@am.sony.com>
    <200709201538.43093.rob@landley.net>
Date: Thu, 20 Sep 2007 23:26:13 +0200 (CEST)
Subject: Re: [Announce] Linux-tiny project revival
From: "Indan Zupancic" <indan@nul.nu>
To: "Rob Landley" <rob@landley.net>
Cc: linux-tiny@selenic.com, "Michael Opdenacker" <michael@free-electrons.com>,
       "CE Linux Developers List" <celinux-dev@tree.celinuxforum.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 12f61b0c8dc8dcc8c992b8e1fde77987
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, September 20, 2007 22:38, Rob Landley wrote:
> I've been playing with an idea for a while to improve the printk() situation,
> but it's a more intrusive change than I've had time to bang on.
>
> Right now, the first argument to printk() is a loglevel, but it's handled via
> string concatenation.  I'd like to change that to be an integer, and make it
> an actual comma-separated first argument.  (Mandatory, not optional.)
>
> So instead of:
>   printk(KERN_NOTICE "Fruit=%d\n", banana);
> It would now be:
>   printk(KERN_NOTICE, "Fruit=%d\n", banana);
>
> Change the header from:
>   #define KERN_NOTICE "<5>"
> to:
>   #define KERN_NOTICE 5

You have to jump through less hoops if you do:

#define KERN_NOTICE 5,

But the problem remains that there are printk's which don't have
a KERN_* as the first argument. Those are also impossible to get
rid off in this way, as the loglevel is unknown (and you don't want
partially printed messages).

So adding the comma is really needed and in addition all printk's
without a loglevel should get one. Which clutters the code and may
increase codesize.

A quick scroll through a vmlinux binary shows that there are quite a
lot areas consisting only of some repeated pattern. Mostly 0x00, but
also 0x90 and ".GCC: (GNU) 4.2.1.". Getting rid of those would save
something between 50 and 100KB.

Greetings,

Indan


