Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbZKRXzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbZKRXzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 18:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756161AbZKRXzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 18:55:47 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:54557 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001AbZKRXzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 18:55:46 -0500
To: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick McHardy <kaber@trash.net>,
       Patrick Mullaney <pmullaney@novell.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       Anna Fischer <anna.fischer@hp.com>, bridge@lists.linux-foundation.org,
       virtualization@linux-foundation.com,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>
Subject: Re: [PATCH 1/3] macvlan: Reflect macvlan packets meant for other macvlan devices
References: <1258497551-25959-1-git-send-email-arnd@arndb.de>
	<200911181047.07974.arnd@arndb.de> <m1pr7fdhkx.fsf@fess.ebiederm.org>
	<200911182332.56309.arnd@arndb.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 18 Nov 2009 15:55:38 -0800
In-Reply-To: <200911182332.56309.arnd@arndb.de> (Arnd Bergmann's message of "Wed\, 18 Nov 2009 23\:32\:56 +0000")
Message-ID: <m1bpiz8k1x.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Wednesday 18 November 2009 14:37:50 Eric W. Biederman wrote:
>> Arnd Bergmann <arnd@arndb.de> writes:
>> > On Wednesday 18 November 2009, Eric Dumazet wrote:
>> >> 
>> >> Why do you drop dst here ?
>> >> 
>> >> It seems strange, since this driver specifically masks out IFF_XMIT_DST_RELEASE
>> >> in its macvlan_setup() :
>> >> 
>> >> dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
>
> It seems that we should never drop dst then. We either forward the frame to
> netif_rx or to dev_queue_xmit, and from how I read it now, we want to keep
> the dst in both cases.

When we loop back on our selves we certainly need to have dst clear because
we don't know how to cache routes through multiple network namespaces.  It
might be handy if we had those but that is a problem for another day.

>> Please copy and ideally share code with the veth driver for recycling a skb.
>> There are bunch of little things you have to do to get it right.  As I recally
>> I was missing a few details in my original patch.
>
> Are you thinking of something like the patch below? I haven't had the chance
> to test this, but one thing it does is to handle the internal forwarding
> differently from the receive path.

Yes.  That is a bit more sharing than I had anticipated, but it looks like
it works.

Eric
