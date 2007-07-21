Return-Path: <linux-kernel-owner+w=401wt.eu-S1765510AbXGUWBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765510AbXGUWBO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760582AbXGUWBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:01:03 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43744 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759591AbXGUWBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:01:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46A28217.2060005@s5r6.in-berlin.de>
Date: Sun, 22 Jul 2007 00:00:55 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       jidong xiao <jidong.xiao@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: what does select statement mean in Kconfig file?
References: <4104961b0707210634gea4e240x11b043b4e64c7840@mail.gmail.com>	<Pine.LNX.4.64.0707210938190.22394@localhost.localdomain>	<46A2397C.4050100@s5r6.in-berlin.de> <m3lkd95tzf.fsf@maximus.localdomain>
In-Reply-To: <m3lkd95tzf.fsf@maximus.localdomain>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Stefan Richter <stefanr@s5r6.in-berlin.de> writes:
> 
>> The latter is sometimes hard or impossible to satisfy.  Therefore the
>> select statement should be used with care, i.e. only for library-type
>> helper code which itself shouldn't depend on further options.
> 
> How about depending on common dependency?
> 
> Something like
> 
> config A
> 	bool XXX
> 	depends on ARM
> 
> config B
> 	depends on ARM
> 	select A
> 
> 
> or:
> 
> if ARM
> 	config A
> 		bool XXX
> endif
> 
> if ARM
> 	config B
> 		select A
> endif

That's OK.  Or generally, if A depends on X and B wants to select A,
then it has to be guaranteed by whatever means that X is enabled,
because "make XYZconfig" cannot select recursively.  Duplicating A's
dependencies as dependencies for B is one way to ensure that A's
dependencies are satisfied when B selects A.  Another way is to select
not only A but also A's dependencies.

That's why I wrote "/shouldn't/ depend on further options" rather than
"/must not/ depend on further options".

But whatever you do, as soon as you add a "select A", you have to watch
if anybody eventually makes A dependent on something else.  Therefore
think twice before you use select.

Also, while select makes it easy for users to enable options, it makes
it somewhat difficult for users to /disable/ options.  So there are also
tradeoffs in usability.  This essentially means that you should never
select huge subsystems.  As I said, only library-like helpers are
suitable for select.
-- 
Stefan Richter
-=====-=-=== -=== =-=-=
http://arcgraph.de/sr/
