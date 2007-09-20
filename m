Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbXITXG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbXITXG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 19:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbXITXGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 19:06:49 -0400
Received: from neon.samage.net ([85.17.153.66]:56561 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbXITXGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 19:06:49 -0400
Message-ID: <38197.81.207.0.53.1190329581.squirrel@secure.samage.net>
In-Reply-To: <200709201818.42125.rob@landley.net>
References: <46F1645D.9050406@am.sony.com>
    <200709201538.43093.rob@landley.net>
    <59465.81.207.0.53.1190323573.squirrel@secure.samage.net>
    <200709201818.42125.rob@landley.net>
Date: Fri, 21 Sep 2007 01:06:21 +0200 (CEST)
Subject: Re: [Announce] Linux-tiny project revival
From: "Indan Zupancic" <indan@nul.nu>
To: "Rob Landley" <rob@landley.net>, "Sam Ravnborg" <sam@ravnborg.org>
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
X-Scan-Signature: 938925967a2432a0d8c7279c30be63be
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, September 21, 2007 01:18, Rob Landley wrote:
> On Thursday 20 September 2007 4:26:13 pm Indan Zupancic wrote:
>> A quick scroll through a vmlinux binary shows that there are quite a
>> lot areas consisting only of some repeated pattern. Mostly 0x00, but
>> also 0x90 and ".GCC: (GNU) 4.2.1.". Getting rid of those would save
>> something between 50 and 100KB.
>
> Worse, if you feed an absolute path to O= when you build the kernel out of
> tree, then it uses absolute paths for all the __FILE__ strings and that makes
> kernel BIIIIIG.  (Did that by accident a while back.)  Too bad there's no way
> to keep the __FILE__ strings compressed at runtime and gunzip them as needed
> like busybox does with help messages... :)

I suspect that can be fixed by changing the built system. How can using O=
change the source file path anyway? That seems unnecessary.

It seems to be worse, full pathnames are also used when giving a relative path.
(I'm using O=../obj/).

On the other hand, it doesn't seem to cause that much bloat here:

$ strings vmlinux | grep /home/ |wc
    119     181    6400

CC'ing Sam Ravnborg, perhaps he has some ideas.

Greetings,

Indan


