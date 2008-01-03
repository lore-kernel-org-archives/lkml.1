Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbYACKhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbYACKhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 05:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYACKhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 05:37:00 -0500
Received: from mail.bmlv.gv.at ([193.171.152.37]:33128 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbYACKg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 05:36:59 -0500
X-Greylist: delayed 1261 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2008 05:36:58 EST
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
To: zippel@linux-m68k.org
Subject: "mconf" and help texts
Date: Thu, 3 Jan 2008 11:15:48 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801031115.48859.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody!

[[ Please keep me CC'ed. Thank you. ]]


I just tried looking at NF_CONNTRACK_MARK (menuconfig, in 2.6.23.12), and 
found it disallowed.

So I took a look at "Help", and saw that blob:

  Selected by: NETFILTER_XT_TARGET_CONNMARK && NET && INET && NETFILTER &&
     NETFILTER_XTABLES && (IP_NF_MANGLE || IP6_NF_MANGLE) && NF_CONNTRACK ||
     NETFILTER_XT_MATCH_CONNMARK && NET && INET && NETFILTER &&
     NETFILTER_XTABLES && NF_CONNTRACK || IP_NF_TARGET_CLUSTERIP && NET &&
     INET && NETFILTER && IP_NF_MANGLE && EXPERIMENTAL && NF_CONNTRACK_IPV4

That is a _bit_ unreadable.


Now breaking that into multiple lines would show me this:
  NETFILTER_XT_TARGET_CONNMARK && NET && INET && NETFILTER &&
     NETFILTER_XTABLES && (IP_NF_MANGLE || IP6_NF_MANGLE) && NF_CONNTRACK ||
  NETFILTER_XT_MATCH_CONNMARK && NET && INET && NETFILTER &&
     NETFILTER_XTABLES && NF_CONNTRACK || 
  IP_NF_TARGET_CLUSTERIP && NET && INET && NETFILTER && IP_NF_MANGLE &&
     EXPERIMENTAL && NF_CONNTRACK_IPV4

Is that correct? If yes, how about putting such line-breaks in the shown text?

Furthermore ... how about removing duplicate symbols from there?
A bit of editing shows me

      1 EXPERIMENTAL
      3 INET
      1 IP6_NF_MANGLE
      2 IP_NF_MANGLE
      1 IP_NF_TARGET_CLUSTERIP
      3 NET
      3 NETFILTER
      2 NETFILTER_XTABLES
      1 NETFILTER_XT_MATCH_CONNMARK
      1 NETFILTER_XT_TARGET_CONNMARK
      2 NF_CONNTRACK
      1 NF_CONNTRACK_IPV4

Now I wonder ... complete reductions of this might be a bit awful, but 
repeated 
	INET && ... ||
	INET && ... ||
	INET && ...
could surely be made shorter.

It would be nice (depending on your value of "nice", of course :-))
to see 
  NET && INET && NETFILTER &&
    NETFILTER_XT_TARGET_CONNMARK && NETFILTER_XTABLES && 
      (IP_NF_MANGLE || IP6_NF_MANGLE) && NF_CONNTRACK ||
  NETFILTER_XT_MATCH_CONNMARK && NETFILTER_XTABLES && NF_CONNTRACK || 
  IP_NF_TARGET_CLUSTERIP && IP_NF_MANGLE && EXPERIMENTAL && NF_CONNTRACK_IPV4

I'm not sure whether it would be worth the additional work to get
  NET && INET && NETFILTER &&
    ( NETFILTER_XTABLES && NF_CONNTRACK &&
      ( NETFILTER_XT_MATCH_CONNMARK && NETFILTER_XTABLES ) ||
      ( NETFILTER_XT_TARGET_CONNMARK && NF_CONNTRACK &&
        (IP_NF_MANGLE || IP6_NF_MANGLE)                     ) ||
    IP_NF_TARGET_CLUSTERIP && IP_NF_MANGLE && EXPERIMENTAL &&
      NF_CONNTRACK_IPV4

(if I translated that correctly, manually)


Would there be interest if I supplied some script (perl would be easiest for 
me) that tried to simplify such strings? Calling that from C wouldn't be 
nice, but acceptable for the occasional help text showing.

There has to be some expression parser for that ... could that be used? Where 
gets this string built?


As a side-node - I cannot get xconfig to work (pkg-config); is there some way 
in menuconfig to see why some config option is disallowed? The location tree 
shows some data ("-> Networking support (NET [=y])"), but not for all 
dependencies. [Does xconfig allow enabling them while seeing this option?]



Regards,

Phil
