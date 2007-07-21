Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbXGUQvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbXGUQvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 12:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbXGUQvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 12:51:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37689 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbXGUQvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 12:51:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46A2397C.4050100@s5r6.in-berlin.de>
Date: Sat, 21 Jul 2007 18:51:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: jidong xiao <jidong.xiao@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: what does select statement mean in Kconfig file?
References: <4104961b0707210634gea4e240x11b043b4e64c7840@mail.gmail.com> <Pine.LNX.4.64.0707210938190.22394@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0707210938190.22394@localhost.localdomain>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Sat, 21 Jul 2007, jidong xiao wrote:
> 
>> Hi,
>> for example, what does the select statement mean?
>>
>> config SERIAL_SH_SCI_CONSOLE
>>        bool "Support for console on SH SCI(F)"
>>        depends on SERIAL_SH_SCI=y
>>        select SERIAL_CORE_CONSOLE
>>
>> Thanks
>> Jason Xiao
> 
> it forces the selection of that option.  it's sort of like a "depends
> on" in reverse.

It's not really in reverse.  It too marks a dependency in the same
direction as "depends on".  But the select statement additionally
instructs "make XYZconfig" programs to
  - expose the dependent option even if the required option is
    disabled,
  - silently enable the required option.

The latter is sometimes hard or impossible to satisfy.  Therefore the
select statement should be used with care, i.e. only for library-type
helper code which itself shouldn't depend on further options.
-- 
Stefan Richter
-=====-=-=== -=== =-=-=
http://arcgraph.de/sr/
