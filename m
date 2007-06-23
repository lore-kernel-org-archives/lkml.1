Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbXFWMCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbXFWMCW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 08:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbXFWMCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 08:02:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:62138 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbXFWMCO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 08:02:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: "upping" a semaphore from interrupt context?
Date: Sat, 23 Jun 2007 14:02:03 +0200
User-Agent: KMail/1.9.6
Cc: Florin Iucha <florin@iucha.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070622173839.GB8398@iucha.net> <200706221934.18436.arnd@arndb.de> <Pine.LNX.4.64.0706230751230.4164@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0706230751230.4164@localhost.localdomain>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706231402.03617.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18VEU6lGvYUhev71OmuO8zfHtJ9acNnuAbFVzj
 caKKTjO0iZ2grEO9VTgRgUH+29tUggH6RvNt9N1vQJ5UUTV1pb
 GhGDwcfagg8wMcU+HvVQg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 June 2007, Robert P. J. Day wrote:
> On Fri, 22 Jun 2007, Arnd Bergmann wrote:
> >
> > yes, but you should not. The use of semaphores is not recommended
> > for new code, it should be replaced with either a mutex or a
> > completion.
> 
> can you clarify this?  it sounds like you're saying that the current
> implementation of semaphores is entirely superfluous.  but surely it
> isn't possible to replace all semaphores with either mutexes or
> completions, is it?

No, not all of them, but the vast majority. There are multiple
differences, the most important one being the 'counting' in
semaphores. You can e.g. define a semaphore that can be held
by N users at the same time, but not more. In a mutex, N is
by definition 1, so only one thread can hold a mutex.

There are other subtle differences in the implementation, e.g.
you cannot mutex_trylock at interrupt time.

	Arnd <><
