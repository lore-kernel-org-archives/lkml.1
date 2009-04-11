Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbZDKQFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbZDKQFu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 12:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbZDKQFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 12:05:37 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:61126 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbZDKQFf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 12:05:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=omjvEOOe2aLqD2wRlyPClGzzOWAFKZjl+qoybsY2DZbp8RA+eBcdRGHe29mVesmnGu
         HfwOGc3NXeIF1/WUZJVm44zS41hxdMpvvqsJTEqZHSck+WBwZmwnC7ZINGJoEmVLL7vM
         QXWgSz+pct9xQT2JC5i9HgDOyz9b3xq8w3UCM=
MIME-Version: 1.0
In-Reply-To: <20090411080739.4cb77370@nehalam>
References: <Pine.LNX.4.64.0904101656190.2093@boston.corp.fedex.com>
	 <20090410095246.4fdccb56@s6510>
	 <20090410.182507.140306636.davem@davemloft.net>
	 <alpine.LFD.2.00.0904101828490.4583@localhost.localdomain>
	 <20090411041533.GB6822@linux.vnet.ibm.com>
	 <alpine.LSU.2.00.0904110657410.26485@fbirervta.pbzchgretzou.qr>
	 <20090411080739.4cb77370@nehalam>
Date: Sun, 12 Apr 2009 00:05:34 +0800
Message-ID: <b6a2187b0904110905kc2cca83ted751b42693b1565@mail.gmail.com>
Subject: Re: iptables very slow after commit 784544739a25c30637397ace5489eeb6e15d7d49
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jan Engelhardt <jengelh@medozas.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, dada1@cosmosbay.com,
       kaber@trash.net, r000n@r000n.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 11:07 PM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
>> iptables works in whole tables. Userspace submits a table, checkentry is
>> called for all rules in the new table, things are swapped, then destroy
>> is called for all rules in the old table. By that logic (which existed
>> since dawn I think), only the swap operation needs to be locked.
> Part of the overhead is the API choice to take counter values from user
> space during the replace.  If the rule replacement just always started with
> zero counters it could be done with less overhead.

It's always good practice to start from zero with these ...

# iptables -F
# iptables -t nat -F
# iptables -X

And most of the time, rules should be put into a file so that it can
rerun easily after reboot. So if it can be speed up for just this
case, it'll help many out there.

Thanks,
Jeff.
