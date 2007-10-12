Return-Path: <linux-kernel-owner+w=401wt.eu-S1760062AbXJLMcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062AbXJLMcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbXJLMcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:32:13 -0400
Received: from stinky.trash.net ([213.144.137.162]:57050 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbXJLMcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:32:11 -0400
Message-ID: <470F6927.9040505@trash.net>
Date: Fri, 12 Oct 2007 14:31:35 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFD] iptables:  mangle table obsoletes filter table
References: <200710120031.42805.a1426z@gawab.com> <200710120837.18152.a1426z@gawab.com> <470F5F19.70606@trash.net> <200710121525.44510.a1426z@gawab.com>
In-Reply-To: <200710121525.44510.a1426z@gawab.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
>>>The problem is that people think they are safe with the filter table,
>>>when in fact they need the prerouting chain to seal things.  Right now
>>>this is only possible in the mangle table.
>>
>>Why do they need PREROUTING?
> 
> 
> Well, for example to stop any transient packets being forwarded.  You could 
> probably hack around this using mark's, but you can't stop the implied route 
> lookup, unless you stop it in prerouting.


This also works fine in FORWARD with a little extra overhead.
If you really have to save resources, you should use PREROUTING/raw
to also avoid the creation of a connection tracking entry.

