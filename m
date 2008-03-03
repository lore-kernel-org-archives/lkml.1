Return-Path: <linux-kernel-owner+w=401wt.eu-S1762370AbYCCXRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762370AbYCCXRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 18:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbYCCXRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 18:17:07 -0500
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:63128 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753989AbYCCXRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 18:17:06 -0500
Date: Tue, 04 Mar 2008 00:18:07 +0100
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Subject: [PATCH-RESEND] Removing unneeded statement from tcp_ipv4.c
In-reply-to: <Pine.LNX.4.64.0803031603100.28251@kivilampi-30.cs.helsinki.fi>
To: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Netdev <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <47CC872F.9020202@nets.rwth-aachen.de>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
X-IronPort-AV: E=Sophos;i="4.25,440,1199660400";   d="scan'208";a="33736817"
References: <47CBFBDA.7000801@nets.rwth-aachen.de>
 <Pine.LNX.4.64.0803031603100.28251@kivilampi-30.cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ilpo Järvinen schrieb:
> On Mon, 3 Mar 2008, Arnd Hannemann wrote:
> 
>> Avoid setting tstamp_ok because this is done two lines later anyway.
>>
>> Signed-off-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
>>
>> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
>> index 00156bf..a28c4c2 100644
>> --- a/net/ipv4/tcp_ipv4.c
>> +++ b/net/ipv4/tcp_ipv4.c
>> @@ -1302,15 +1302,14 @@ int tcp_v4_conn_request(struct sock *sk, struct sk_buff *skb)
>>                 tmp_opt.saw_tstamp = 0;
>>         }
>>
>> -       if (tmp_opt.saw_tstamp && !tmp_opt.rcv_tsval) {
>> +       if (tmp_opt.saw_tstamp && !tmp_opt.rcv_tsval)
>>                 /* Some OSes (unknown ones, but I see them on web server, which
>>                  * contains information interesting only for windows'
>>                  * users) do not send their stamp in SYN. It is easy case.
>>                  * We simply do not advertise TS support.
>>                  */
>>                 tmp_opt.saw_tstamp = 0;
>> -               tmp_opt.tstamp_ok 
> 
> Please move the comment before the if (), only then can you remove those 
> braces safely (without affecting readability, etc.).

Avoid setting tstamp_ok because this is done two lines later anyway.

Signed-off-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 00156bf..ecef356 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1302,15 +1302,14 @@ int tcp_v4_conn_request(struct sock *sk, struct sk_buff *skb)
                tmp_opt.saw_tstamp = 0;
        }

-       if (tmp_opt.saw_tstamp && !tmp_opt.rcv_tsval) {
-               /* Some OSes (unknown ones, but I see them on web server, which
-                * contains information interesting only for windows'
-                * users) do not send their stamp in SYN. It is easy case.
-                * We simply do not advertise TS support.
-                */
+       /* Some OSes (unknown ones, but I see them on web server, which
+        * contains information interesting only for windows'
+        * users) do not send their stamp in SYN. It is easy case.
+        * We simply do not advertise TS support.
+        */
+       if (tmp_opt.saw_tstamp && !tmp_opt.rcv_tsval)
                tmp_opt.saw_tstamp = 0;
-               tmp_opt.tstamp_ok  = 0;
-       }
+
        tmp_opt.tstamp_ok = tmp_opt.saw_tstamp;

        tcp_openreq_init(req, &tmp_opt, skb);

