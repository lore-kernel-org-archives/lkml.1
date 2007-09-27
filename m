Return-Path: <linux-kernel-owner+w=401wt.eu-S1759917AbXI0Wfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917AbXI0Wfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 18:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758311AbXI0Wfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 18:35:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61524 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbXI0Wfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 18:35:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Indan Zupancic" <indan@nul.nu>
Subject: Re: [Announce] Linux-tiny project revival
Date: Fri, 28 Sep 2007 00:21:33 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070831.706792)
References: <46F1645D.9050406@am.sony.com> <200709270900.36602.arnd@arndb.de> <39129.81.207.0.53.1190910941.squirrel@secure.samage.net>
In-Reply-To: <39129.81.207.0.53.1190910941.squirrel@secure.samage.net>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
Cc: "Rob Landley" <rob@landley.net>,
       "Michael Opdenacker" <michael@free-electrons.com>,
       linux-tiny@selenic.com,
       "CE Linux Developers List" <celinux-dev@tree.celinuxforum.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709280021.34783.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1930H47ouZOWyQB39NPMak9MtuutrgJVYlgTpS
 fJDDMbrjKOjpvzNs6tIT6mQJM0pBqe++y4jVtE5lYZ1HP6zJCq
 7MsSwG1IPf0ddEv3IFPHw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 September 2007, you wrote:
> > Then you don't have to change every single printk in the kernel, but
> > only those that don't currently come with a log level. More importantly,
> > you can do the conversion without a flag day, by spreading (an empty)
> > PRINTK_CONTINUED in places that do need a printk without a log level.
> 
> The problem is, how do you know whether to print a continued printk or not?
> It depends on the loglevel of the first printk.

Those need to be looked at individually. You can normally see easily from
the context whether the missing log level was an accident, or the author
actually has multiple printk statements for a single line. In one case,
you would add a log level, in the other case, you can add PRINTK_CONTINUED,
or something similar. An alternative to PRINTK_CONTINUED might be a new
function, e.g. printk_continued() or similar that does not expect a log
level.

> So besides compile-time parsing of the source code, replacing printk with
> loglevel specific alternatives (one way or the other) seems the only option.

That would mean replacing all of them, not just those that currently lack
a loglevel.

	Arnd <><
