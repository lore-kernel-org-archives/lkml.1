Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbXEIONO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbXEIONO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 10:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbXEIOM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 10:12:59 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:34297 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbXEIOM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 10:12:58 -0400
From: Anant Nitya <kernel@prachanda.info>
Organization: Prachanda Hub
To: linux-kernel@vger.kernel.org
Subject: [BUG] local_softirq_pending storm
Date: Wed, 9 May 2007 19:42:22 +0530
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 25999
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200705091942.22920.kernel@prachanda.hub>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Ever since I upgrade to 2.6.21/.1, system log is filled with following 
messages if I enable CONFIG_NO_HZ=y, going through archives it seems ingo 
sometime back posted some patch and now it is upstream, but its not helping 
here. If I disable NOHZ by kernel command line nohz=off this problem 
disappears. This system is P4/2.40GHz/HT with SMP/SMT on in kernel config. 
One more thing that I noticed is this problem only arises while using X or 
network otherwise plain command line with no network access don't trigger 
this with nohz=on.
Please ask if more information is required regarding this setup.

dumdum@hahakaar [~]$ >>  grep NOHZ /var/log/messages
May  8 03:38:14 rudra kernel: [  419.271195] NOHZ: local_softirq_pending 02
May  8 03:38:14 rudra kernel: [  419.271663] NOHZ: local_softirq_pending 02
May  8 03:38:14 rudra kernel: [  419.343948] NOHZ: local_softirq_pending 22
May  8 03:38:14 rudra kernel: [  419.344236] NOHZ: local_softirq_pending 22
May  8 03:38:14 rudra kernel: [  419.344397] NOHZ: local_softirq_pending 22
May  8 03:38:14 rudra kernel: [  419.344545] NOHZ: local_softirq_pending 22
May  8 03:38:14 rudra kernel: [  419.344691] NOHZ: local_softirq_pending 22
May  8 03:38:14 rudra kernel: [  419.344842] NOHZ: local_softirq_pending 22
May  8 03:38:14 rudra kernel: [  419.344991] NOHZ: local_softirq_pending 22
May  8 03:38:14 rudra kernel: [  419.345137] NOHZ: local_softirq_pending 22
May  8 03:38:18 rudra kernel: [  423.065780] NOHZ: local_softirq_pending 22
May  8 03:38:18 rudra kernel: [  423.066206] NOHZ: local_softirq_pending 22
May  8 03:38:18 rudra kernel: [  423.066509] NOHZ: local_softirq_pending 22
May  8 03:38:19 rudra kernel: [  424.006549] NOHZ: local_softirq_pending 22
May  8 03:38:19 rudra kernel: [  424.006983] NOHZ: local_softirq_pending 22
May  8 03:38:19 rudra kernel: [  424.007239] NOHZ: local_softirq_pending 22
May  8 03:38:19 rudra kernel: [  424.007473] NOHZ: local_softirq_pending 22
May  8 03:38:19 rudra kernel: [  424.007706] NOHZ: local_softirq_pending 22
May  8 03:38:19 rudra kernel: [  424.007941] NOHZ: local_softirq_pending 22
May  8 03:38:22 rudra kernel: [  426.862456] NOHZ: local_softirq_pending 22
May  8 03:38:23 rudra kernel: [  428.331619] NOHZ: local_softirq_pending 22
May  8 03:38:23 rudra kernel: [  428.331991] NOHZ: local_softirq_pending 22
May  8 03:38:23 rudra kernel: [  428.332192] NOHZ: local_softirq_pending 22
May  8 03:38:23 rudra kernel: [  428.332378] NOHZ: local_softirq_pending 22
May  8 03:38:23 rudra kernel: [  428.332553] NOHZ: local_softirq_pending 22
May  8 03:38:23 rudra kernel: [  428.332740] NOHZ: local_softirq_pending 22
May  8 03:38:23 rudra kernel: [  428.332914] NOHZ: local_softirq_pending 22
May  8 03:38:23 rudra kernel: [  428.333097] NOHZ: local_softirq_pending 22
May  8 03:38:23 rudra kernel: [  428.333271] NOHZ: local_softirq_pending 22
May  8 03:38:23 rudra kernel: [  428.333443] NOHZ: local_softirq_pending 22
May  8 03:38:23 rudra kernel: [  428.333619] NOHZ: local_softirq_pending 22
May  8 03:38:24 rudra kernel: [  429.261574] NOHZ: local_softirq_pending 22
May  8 03:38:24 rudra kernel: [  429.262024] NOHZ: local_softirq_pending 22
May  8 03:38:24 rudra kernel: [  429.262339] NOHZ: local_softirq_pending 22
May  8 03:38:24 rudra kernel: [  429.262610] NOHZ: local_softirq_pending 22
May  8 03:38:24 rudra kernel: [  429.262847] NOHZ: local_softirq_pending 22
May  8 03:38:24 rudra kernel: [  429.263081] NOHZ: local_softirq_pending 22
May  8 03:38:35 rudra kernel: [  440.182998] NOHZ: local_softirq_pending 22
May  8 03:38:35 rudra kernel: [  440.183408] NOHZ: local_softirq_pending 22
May  8 03:38:35 rudra kernel: [  440.183661] NOHZ: local_softirq_pending 22
May  8 03:38:43 rudra kernel: [  448.272087] NOHZ: local_softirq_pending 22
May  8 03:38:43 rudra kernel: [  448.272529] NOHZ: local_softirq_pending 22
May  8 03:38:44 rudra kernel: [  449.223360] NOHZ: local_softirq_pending 22
May  8 03:38:44 rudra kernel: [  449.223887] NOHZ: local_softirq_pending 22
May  8 03:38:44 rudra kernel: [  449.224570] NOHZ: local_softirq_pending 22
May  8 03:38:44 rudra kernel: [  449.225066] NOHZ: local_softirq_pending 22
May  8 03:38:44 rudra kernel: [  449.232989] NOHZ: local_softirq_pending 22
May  8 03:38:47 rudra kernel: [  452.178583] NOHZ: local_softirq_pending a2
May  8 03:38:47 rudra kernel: [  452.179017] NOHZ: local_softirq_pending a2
May  8 03:38:47 rudra kernel: [  452.179257] NOHZ: local_softirq_pending a2
May  8 03:38:51 rudra kernel: [  455.957968] NOHZ: local_softirq_pending 22
May  8 03:38:51 rudra kernel: [  455.958462] NOHZ: local_softirq_pending 22
May  8 03:38:51 rudra kernel: [  455.958741] NOHZ: local_softirq_pending 22
May  8 03:38:51 rudra kernel: [  455.958984] NOHZ: local_softirq_pending 22
May  8 03:38:51 rudra kernel: [  455.959292] NOHZ: local_softirq_pending 22
May  8 03:38:51 rudra kernel: [  455.959540] NOHZ: local_softirq_pending 22
May  8 03:38:51 rudra kernel: [  455.959774] NOHZ: local_softirq_pending 22
May  8 03:38:51 rudra kernel: [  455.960005] NOHZ: local_softirq_pending 22
May  8 03:38:51 rudra kernel: [  455.972368] NOHZ: local_softirq_pending 10
May  8 03:38:51 rudra kernel: [  455.972681] NOHZ: local_softirq_pending 10
May  8 03:38:51 rudra kernel: [  455.972884] NOHZ: local_softirq_pending 10
May  8 03:38:51 rudra kernel: [  455.973069] NOHZ: local_softirq_pending 10
May  8 03:38:51 rudra kernel: [  455.973251] NOHZ: local_softirq_pending 10
May  8 03:38:51 rudra kernel: [  455.973433] NOHZ: local_softirq_pending 10
May  8 03:38:51 rudra kernel: [  455.973631] NOHZ: local_softirq_pending 10
May  8 03:38:51 rudra kernel: [  455.973832] NOHZ: local_softirq_pending 10
May  8 03:38:51 rudra kernel: [  455.974018] NOHZ: local_softirq_pending 10
May  8 03:38:51 rudra kernel: [  455.974234] NOHZ: local_softirq_pending 10
May  8 03:38:51 rudra kernel: [  455.974422] NOHZ: local_softirq_pending 10
May  8 03:38:51 rudra kernel: [  455.974610] NOHZ: local_softirq_pending 10
May  8 03:38:51 rudra kernel: [  455.974791] NOHZ: local_softirq_pending 10
May  8 03:38:51 rudra kernel: [  455.974981] NOHZ: local_softirq_pending 10
May  8 03:38:51 rudra kernel: [  455.975194] NOHZ: local_softirq_pending 10
May  8 03:38:51 rudra kernel: [  455.975390] NOHZ: local_softirq_pending 10
May  8 03:38:51 rudra kernel: [  455.975570] NOHZ: local_softirq_pending 10
May  8 03:38:51 rudra kernel: [  455.976091] NOHZ: local_softirq_pending 22
May  8 03:38:51 rudra kernel: [  455.976376] NOHZ: local_softirq_pending 22
May  8 03:38:51 rudra kernel: [  455.976622] NOHZ: local_softirq_pending 22
May  8 03:38:51 rudra kernel: [  455.976862] NOHZ: local_softirq_pending 22
May  8 03:38:51 rudra kernel: [  455.977099] NOHZ: local_softirq_pending 22
May  8 03:38:51 rudra kernel: [  455.977337] NOHZ: local_softirq_pending 22
May  8 03:38:51 rudra kernel: [  455.977577] NOHZ: local_softirq_pending 22
May  8 03:38:51 rudra kernel: [  455.977815] NOHZ: local_softirq_pending 22
May  8 03:38:52 rudra kernel: [  456.848267] NOHZ: local_softirq_pending 22
May  8 03:38:52 rudra kernel: [  456.848726] NOHZ: local_softirq_pending 22
May  8 03:38:52 rudra kernel: [  456.848982] NOHZ: local_softirq_pending 22
May  8 03:38:52 rudra kernel: [  456.849223] NOHZ: local_softirq_pending 22
May  8 03:38:52 rudra kernel: [  456.849459] NOHZ: local_softirq_pending 22
May  8 03:38:54 rudra kernel: [  459.279942] NOHZ: local_softirq_pending 02
May  8 03:38:54 rudra kernel: [  459.280267] NOHZ: local_softirq_pending 02
May  8 03:38:54 rudra kernel: [  459.280477] NOHZ: local_softirq_pending 02
May  8 03:38:54 rudra kernel: [  459.280667] NOHZ: local_softirq_pending 02
May  8 03:38:54 rudra kernel: [  459.280865] NOHZ: local_softirq_pending 02
May  8 03:38:59 rudra kernel: [  464.046556] NOHZ: local_softirq_pending 22
May  8 03:38:59 rudra kernel: [  464.046999] NOHZ: local_softirq_pending 22
May  8 03:38:59 rudra kernel: [  464.047315] NOHZ: local_softirq_pending 22
May  8 03:38:59 rudra kernel: [  464.047554] NOHZ: local_softirq_pending 22
May  8 03:38:59 rudra kernel: [  464.047790] NOHZ: local_softirq_pending 22
May  8 03:39:08 rudra kernel: [  473.019484] NOHZ: local_softirq_pending a2
May  8 03:39:08 rudra kernel: [  473.019954] NOHZ: local_softirq_pending a2
May  8 03:39:08 rudra kernel: [  473.020215] NOHZ: local_softirq_pending a2
May  8 03:39:08 rudra kernel: [  473.020455] NOHZ: local_softirq_pending a2
May  8 03:39:08 rudra kernel: [  473.020692] NOHZ: local_softirq_pending a2
May  8 03:39:08 rudra kernel: [  473.020925] NOHZ: local_softirq_pending a2
May  8 03:39:11 rudra kernel: [  475.876271] NOHZ: local_softirq_pending 22
May  8 03:39:11 rudra kernel: [  475.876697] NOHZ: local_softirq_pending 22
May  8 03:39:11 rudra kernel: [  475.876947] NOHZ: local_softirq_pending 22
May  8 03:39:11 rudra kernel: [  475.877183] NOHZ: local_softirq_pending 22
May  8 03:39:11 rudra kernel: [  475.877490] NOHZ: local_softirq_pending 22
May  8 03:39:11 rudra kernel: [  475.877736] NOHZ: local_softirq_pending 22
May  8 03:39:11 rudra kernel: [  475.877964] NOHZ: local_softirq_pending 22
May  8 03:39:31 rudra kernel: [  495.878914] NOHZ: local_softirq_pending 22
May  8 03:39:31 rudra kernel: [  495.879262] NOHZ: local_softirq_pending 22
May  8 03:39:31 rudra kernel: [  495.879473] NOHZ: local_softirq_pending 22
May  8 03:39:31 rudra kernel: [  495.879674] NOHZ: local_softirq_pending 22
May  8 03:39:31 rudra kernel: [  495.879849] NOHZ: local_softirq_pending 22
May  8 03:39:31 rudra kernel: [  495.880031] NOHZ: local_softirq_pending 22
May  8 03:39:31 rudra kernel: [  495.880206] NOHZ: local_softirq_pending 22
May  8 03:39:53 rudra kernel: [  517.755212] NOHZ: local_softirq_pending 22
May  8 03:39:53 rudra kernel: [  517.755863] NOHZ: local_softirq_pending 22
May  8 03:39:53 rudra kernel: [  517.756181] NOHZ: local_softirq_pending 22
May  8 03:39:53 rudra kernel: [  517.756434] NOHZ: local_softirq_pending 22
May  8 03:39:53 rudra kernel: [  517.756667] NOHZ: local_softirq_pending 22
May  8 03:39:53 rudra kernel: [  517.756900] NOHZ: local_softirq_pending 22
May  8 03:39:54 rudra kernel: [  518.718220] NOHZ: local_softirq_pending 22
May  8 03:39:54 rudra kernel: [  518.718540] NOHZ: local_softirq_pending 22
May  8 03:39:54 rudra kernel: [  518.718756] NOHZ: local_softirq_pending 22
May  8 03:39:54 rudra kernel: [  518.718944] NOHZ: local_softirq_pending 22
May  8 03:39:54 rudra kernel: [  518.719121] NOHZ: local_softirq_pending 22
May  8 03:39:54 rudra kernel: [  518.719298] NOHZ: local_softirq_pending 22
May  8 03:39:54 rudra kernel: [  518.719484] NOHZ: local_softirq_pending 22
May  8 03:39:54 rudra kernel: [  518.719672] NOHZ: local_softirq_pending 22
May  8 03:40:02 rudra kernel: [  526.814840] NOHZ: local_softirq_pending 22
May  8 03:40:02 rudra kernel: [  526.815354] NOHZ: local_softirq_pending 22
May  8 03:40:02 rudra kernel: [  526.815703] NOHZ: local_softirq_pending 22
May  8 03:40:02 rudra kernel: [  526.816015] NOHZ: local_softirq_pending 22
May  8 03:40:02 rudra kernel: [  526.816255] NOHZ: local_softirq_pending 22
May  8 03:40:11 rudra kernel: [  535.847890] NOHZ: local_softirq_pending a2
May  8 03:40:11 rudra kernel: [  535.848360] NOHZ: local_softirq_pending a2
May  8 03:40:11 rudra kernel: [  535.848618] NOHZ: local_softirq_pending a2
May  8 03:40:11 rudra kernel: [  535.848857] NOHZ: local_softirq_pending a2
May  8 03:40:11 rudra kernel: [  535.849095] NOHZ: local_softirq_pending a2
May  8 03:40:12 rudra kernel: [  536.788182] NOHZ: local_softirq_pending 22
May  8 03:40:12 rudra kernel: [  536.788630] NOHZ: local_softirq_pending 22
May  8 03:40:12 rudra kernel: [  536.788939] NOHZ: local_softirq_pending 22
May  8 03:40:12 rudra kernel: [  536.789240] NOHZ: local_softirq_pending 22
May  8 03:40:12 rudra kernel: [  536.789484] NOHZ: local_softirq_pending 22
May  8 03:40:12 rudra kernel: [  536.789718] NOHZ: local_softirq_pending 22
May  8 03:40:16 rudra kernel: [  541.078474] NOHZ: local_softirq_pending a2
May  8 03:40:16 rudra kernel: [  541.078933] NOHZ: local_softirq_pending a2
May  8 03:40:16 rudra kernel: [  541.079186] NOHZ: local_softirq_pending a2
May  8 03:40:16 rudra kernel: [  541.079425] NOHZ: local_softirq_pending a2
May  8 03:40:16 rudra kernel: [  541.079657] NOHZ: local_softirq_pending a2
May  8 03:40:16 rudra kernel: [  541.079893] NOHZ: local_softirq_pending a2
May  8 03:40:18 rudra kernel: [  542.974969] NOHZ: local_softirq_pending 22
May  8 03:40:18 rudra kernel: [  542.975419] NOHZ: local_softirq_pending 22
May  8 03:40:18 rudra kernel: [  542.975754] NOHZ: local_softirq_pending 22
May  8 03:40:18 rudra kernel: [  542.976018] NOHZ: local_softirq_pending 22
May  8 03:40:18 rudra kernel: [  542.976253] NOHZ: local_softirq_pending 22
May  8 03:40:18 rudra kernel: [  542.976484] NOHZ: local_softirq_pending 22
May  8 03:40:24 rudra kernel: [  548.687200] NOHZ: local_softirq_pending a2
May  8 03:40:24 rudra kernel: [  548.687691] NOHZ: local_softirq_pending a2
May  8 03:40:28 rudra kernel: [  552.977399] NOHZ: local_softirq_pending a2
May  8 03:40:28 rudra kernel: [  552.977730] NOHZ: local_softirq_pending a2
May  8 03:40:28 rudra kernel: [  552.977946] NOHZ: local_softirq_pending a2
May  8 03:40:28 rudra kernel: [  552.978135] NOHZ: local_softirq_pending a2
May  8 03:40:28 rudra kernel: [  552.978318] NOHZ: local_softirq_pending a2
May  8 03:40:28 rudra kernel: [  552.978499] NOHZ: local_softirq_pending a2
May  8 03:40:28 rudra kernel: [  552.978708] NOHZ: local_softirq_pending a2
May  8 03:40:33 rudra kernel: [  557.728762] NOHZ: local_softirq_pending 22
May  8 03:40:33 rudra kernel: [  557.729230] NOHZ: local_softirq_pending 22
May  8 03:40:33 rudra kernel: [  557.729539] NOHZ: local_softirq_pending 22
May  8 03:40:33 rudra kernel: [  557.729821] NOHZ: local_softirq_pending 22
May  8 03:40:33 rudra kernel: [  557.730060] NOHZ: local_softirq_pending 22
May  8 03:40:33 rudra kernel: [  557.730297] NOHZ: local_softirq_pending 22
May  8 03:40:36 rudra kernel: [  561.065192] NOHZ: local_softirq_pending e2
May  8 03:40:36 rudra kernel: [  561.065539] NOHZ: local_softirq_pending e2
May  8 03:40:36 rudra kernel: [  561.065750] NOHZ: local_softirq_pending e2
May  8 03:40:36 rudra kernel: [  561.065942] NOHZ: local_softirq_pending e2
May  8 03:40:36 rudra kernel: [  561.066139] NOHZ: local_softirq_pending e2
May  8 03:40:36 rudra kernel: [  561.066339] NOHZ: local_softirq_pending e2
May  8 03:40:36 rudra kernel: [  561.066515] NOHZ: local_softirq_pending e2
May  8 03:40:42 rudra kernel: [  566.772651] NOHZ: local_softirq_pending 22
May  8 03:40:42 rudra kernel: [  566.773108] NOHZ: local_softirq_pending 22
May  8 03:40:42 rudra kernel: [  566.773314] NOHZ: local_softirq_pending 22
May  8 03:40:42 rudra kernel: [  566.773359] NOHZ: local_softirq_pending 22
May  8 03:40:42 rudra kernel: [  566.787249] NOHZ: local_softirq_pending 62
May  8 03:40:42 rudra kernel: [  566.787536] NOHZ: local_softirq_pending 62
May  8 03:40:51 rudra kernel: [  575.816602] NOHZ: local_softirq_pending 22
May  8 03:40:51 rudra kernel: [  575.817065] NOHZ: local_softirq_pending 22
May  8 03:41:03 rudra kernel: [  587.715470] NOHZ: local_softirq_pending 22
May  8 03:41:03 rudra kernel: [  587.715920] NOHZ: local_softirq_pending 22
May  8 03:41:03 rudra kernel: [  587.716259] NOHZ: local_softirq_pending 22
May  8 03:41:03 rudra kernel: [  587.716528] NOHZ: local_softirq_pending 22
May  8 03:41:03 rudra kernel: [  587.716764] NOHZ: local_softirq_pending 22
May  8 03:41:03 rudra kernel: [  587.717001] NOHZ: local_softirq_pending 22
May  8 03:41:12 rudra kernel: [  596.805445] NOHZ: local_softirq_pending 22
May  8 03:41:12 rudra kernel: [  596.805945] NOHZ: local_softirq_pending 22
May  8 03:41:12 rudra kernel: [  596.806196] NOHZ: local_softirq_pending 22
May  8 03:41:12 rudra kernel: [  596.806430] NOHZ: local_softirq_pending 22
May  8 03:41:12 rudra kernel: [  596.806659] NOHZ: local_softirq_pending 22
May  8 03:41:12 rudra kernel: [  596.806888] NOHZ: local_softirq_pending 22
May  8 03:41:12 rudra kernel: [  596.807116] NOHZ: local_softirq_pending 22
May  8 03:41:12 rudra kernel: [  596.807341] NOHZ: local_softirq_pending 22
May  8 03:41:12 rudra kernel: [  596.807570] NOHZ: local_softirq_pending 22
May  8 03:41:20 rudra kernel: [  604.847182] NOHZ: local_softirq_pending 22
May  8 03:41:20 rudra kernel: [  604.847637] NOHZ: local_softirq_pending 22
May  8 03:41:20 rudra kernel: [  604.847941] NOHZ: local_softirq_pending 22
May  8 03:41:20 rudra kernel: [  604.848225] NOHZ: local_softirq_pending 22
May  8 03:41:20 rudra kernel: [  604.848463] NOHZ: local_softirq_pending 22
May  8 03:41:20 rudra kernel: [  604.848700] NOHZ: local_softirq_pending 22
May  8 03:41:23 rudra kernel: [  607.702270] NOHZ: local_softirq_pending 22
May  8 03:41:23 rudra kernel: [  607.702604] NOHZ: local_softirq_pending 22
May  8 03:41:23 rudra kernel: [  607.702804] NOHZ: local_softirq_pending 22
May  8 03:41:23 rudra kernel: [  607.702982] NOHZ: local_softirq_pending 22
May  8 03:41:23 rudra kernel: [  607.703181] NOHZ: local_softirq_pending 22
May  8 03:41:23 rudra kernel: [  607.703431] NOHZ: local_softirq_pending 22
May  8 03:41:23 rudra kernel: [  607.703621] NOHZ: local_softirq_pending 22
May  8 03:41:29 rudra kernel: [  613.888941] NOHZ: local_softirq_pending 22
May  8 03:41:29 rudra kernel: [  613.889415] NOHZ: local_softirq_pending 22
May  8 03:41:29 rudra kernel: [  613.889712] NOHZ: local_softirq_pending 22
May  8 03:41:29 rudra kernel: [  613.890009] NOHZ: local_softirq_pending 22
May  8 03:41:29 rudra kernel: [  613.890251] NOHZ: local_softirq_pending 22
May  8 03:41:29 rudra kernel: [  613.890487] NOHZ: local_softirq_pending 22
May  8 03:41:32 rudra kernel: [  616.743862] NOHZ: local_softirq_pending 22
May  8 03:41:32 rudra kernel: [  616.744331] NOHZ: local_softirq_pending 22
May  8 03:41:32 rudra kernel: [  616.744640] NOHZ: local_softirq_pending 22
May  8 03:41:32 rudra kernel: [  616.744929] NOHZ: local_softirq_pending 22
May  8 03:41:32 rudra kernel: [  616.745175] NOHZ: local_softirq_pending 22
May  8 03:41:32 rudra kernel: [  616.745409] NOHZ: local_softirq_pending 22
May  8 03:41:34 rudra kernel: [  618.660611] NOHZ: local_softirq_pending a2
May  8 03:41:34 rudra kernel: [  618.660958] NOHZ: local_softirq_pending a2
May  8 03:41:34 rudra kernel: [  618.661166] NOHZ: local_softirq_pending a2
May  8 03:41:34 rudra kernel: [  618.661349] NOHZ: local_softirq_pending a2
May  8 03:41:34 rudra kernel: [  618.661541] NOHZ: local_softirq_pending a2
May  8 03:41:34 rudra kernel: [  618.661729] NOHZ: local_softirq_pending a2
May  8 03:41:34 rudra kernel: [  618.661911] NOHZ: local_softirq_pending a2
May  8 03:41:34 rudra kernel: [  618.662089] NOHZ: local_softirq_pending a2
May  8 03:41:37 rudra kernel: [  621.996786] NOHZ: local_softirq_pending 22
May  8 03:41:50 rudra kernel: [  634.831692] NOHZ: local_softirq_pending 22
May  8 03:41:50 rudra kernel: [  634.832143] NOHZ: local_softirq_pending 22
May  8 03:41:50 rudra kernel: [  634.832453] NOHZ: local_softirq_pending 22
May  8 03:41:50 rudra kernel: [  634.832765] NOHZ: local_softirq_pending 22
May  8 03:41:50 rudra kernel: [  634.833011] NOHZ: local_softirq_pending 22
May  8 03:41:50 rudra kernel: [  634.833241] NOHZ: local_softirq_pending 22
May  8 03:41:51 rudra kernel: [  635.790271] NOHZ: local_softirq_pending a2
May  8 03:41:51 rudra kernel: [  635.790608] NOHZ: local_softirq_pending a2
May  8 03:41:51 rudra kernel: [  635.790823] NOHZ: local_softirq_pending a2
May  8 03:41:51 rudra kernel: [  635.791001] NOHZ: local_softirq_pending a2
May  8 03:41:51 rudra kernel: [  635.791179] NOHZ: local_softirq_pending a2
May  8 03:41:51 rudra kernel: [  635.791354] NOHZ: local_softirq_pending a2
May  8 03:41:51 rudra kernel: [  635.791537] NOHZ: local_softirq_pending a2
May  8 03:41:53 rudra kernel: [  637.686505] NOHZ: local_softirq_pending 22
May  8 03:41:53 rudra kernel: [  637.686981] NOHZ: local_softirq_pending 22
May  8 03:41:53 rudra kernel: [  637.687428] NOHZ: local_softirq_pending 22
May  8 03:42:08 rudra kernel: [  652.941445] NOHZ: local_softirq_pending 22
May  8 03:42:08 rudra kernel: [  652.941976] NOHZ: local_softirq_pending 22
May  8 03:42:08 rudra kernel: [  652.942243] NOHZ: local_softirq_pending 22
May  8 03:42:08 rudra kernel: [  652.942485] NOHZ: local_softirq_pending 22
May  8 03:42:08 rudra kernel: [  652.942717] NOHZ: local_softirq_pending 22
May  8 03:42:08 rudra kernel: [  652.942953] NOHZ: local_softirq_pending 22
May  8 03:42:08 rudra kernel: [  652.943188] NOHZ: local_softirq_pending 22
May  8 03:42:09 rudra kernel: [  653.862586] NOHZ: local_softirq_pending 22
May  8 03:42:09 rudra kernel: [  653.862918] NOHZ: local_softirq_pending 22
May  8 03:42:09 rudra kernel: [  653.863124] NOHZ: local_softirq_pending 22
May  8 03:42:09 rudra kernel: [  653.863316] NOHZ: local_softirq_pending 22
May  8 03:42:09 rudra kernel: [  653.863501] NOHZ: local_softirq_pending 22
May  8 03:42:09 rudra kernel: [  653.863687] NOHZ: local_softirq_pending 22
May  8 03:42:09 rudra kernel: [  653.863863] NOHZ: local_softirq_pending 22
May  8 03:42:12 rudra kernel: [  656.714675] NOHZ: local_softirq_pending 22
May  8 03:42:12 rudra kernel: [  656.715163] NOHZ: local_softirq_pending 22
May  8 03:42:12 rudra kernel: [  656.715423] NOHZ: local_softirq_pending 22
May  8 03:42:12 rudra kernel: [  656.715665] NOHZ: local_softirq_pending 22
May  8 03:42:12 rudra kernel: [  656.715904] NOHZ: local_softirq_pending 22
May  8 03:42:12 rudra kernel: [  656.716140] NOHZ: local_softirq_pending 22
May  8 03:42:12 rudra kernel: [  656.716378] NOHZ: local_softirq_pending 22
May  8 03:42:12 rudra kernel: [  656.716611] NOHZ: local_softirq_pending 22
May  8 03:42:14 rudra kernel: [  658.622576] NOHZ: local_softirq_pending 22
May  8 03:42:15 rudra kernel: [  659.569910] NOHZ: local_softirq_pending 22
May  8 03:42:15 rudra kernel: [  659.570340] NOHZ: local_softirq_pending 22
May  8 03:42:15 rudra kernel: [  659.570650] NOHZ: local_softirq_pending 22
May  8 03:42:15 rudra kernel: [  659.570924] NOHZ: local_softirq_pending 22
May  8 03:42:15 rudra kernel: [  659.571159] NOHZ: local_softirq_pending 22
May  8 03:42:15 rudra kernel: [  659.571393] NOHZ: local_softirq_pending 22
May  9 01:10:43 rudra kernel: [ 4472.241952] NOHZ: local_softirq_pending 22
May  9 01:10:43 rudra kernel: [ 4472.243018] NOHZ: local_softirq_pending 22
May  9 01:10:43 rudra kernel: [ 4472.243383] NOHZ: local_softirq_pending 22
May  9 01:11:15 rudra kernel: [ 4504.194191] NOHZ: local_softirq_pending 22
May  9 01:11:15 rudra kernel: [ 4504.194815] NOHZ: local_softirq_pending 22
May  9 01:11:15 rudra kernel: [ 4504.195140] NOHZ: local_softirq_pending 22
May  9 01:11:35 rudra kernel: [ 4524.158524] NOHZ: local_softirq_pending 22
May  9 01:11:35 rudra kernel: [ 4524.159118] NOHZ: local_softirq_pending 22
May  9 01:11:35 rudra kernel: [ 4524.159439] NOHZ: local_softirq_pending 22
May  9 01:11:45 rudra kernel: [ 4534.140638] NOHZ: local_softirq_pending 22
May  9 01:11:45 rudra kernel: [ 4534.141046] NOHZ: local_softirq_pending 22
May  9 01:11:45 rudra kernel: [ 4534.141456] NOHZ: local_softirq_pending 22
May  9 01:11:45 rudra kernel: [ 4534.141738] NOHZ: local_softirq_pending 22
May  9 01:12:32 rudra kernel: [ 4580.718873] NOHZ: local_softirq_pending 22
May  9 01:12:32 rudra kernel: [ 4580.719297] NOHZ: local_softirq_pending 22
May  9 01:12:32 rudra kernel: [ 4580.719557] NOHZ: local_softirq_pending 22
May  9 01:12:32 rudra kernel: [ 4580.719808] NOHZ: local_softirq_pending 22
May  9 01:12:32 rudra kernel: [ 4580.720047] NOHZ: local_softirq_pending 22
May  9 01:12:32 rudra kernel: [ 4580.720295] NOHZ: local_softirq_pending 22
May  9 01:12:32 rudra kernel: [ 4580.720534] NOHZ: local_softirq_pending 22
May  9 01:12:36 rudra kernel: [ 4585.053403] NOHZ: local_softirq_pending 22
May  9 01:12:36 rudra kernel: [ 4585.054308] NOHZ: local_softirq_pending 22
May  9 01:12:36 rudra kernel: [ 4585.054588] NOHZ: local_softirq_pending 22
May  9 01:12:36 rudra kernel: [ 4585.054796] NOHZ: local_softirq_pending 22
May  9 01:12:36 rudra kernel: [ 4585.054981] NOHZ: local_softirq_pending 22
May  9 01:12:36 rudra kernel: [ 4585.055163] NOHZ: local_softirq_pending 22
May  9 01:12:38 rudra kernel: [ 4586.927035] NOHZ: local_softirq_pending 22
May  9 01:12:51 rudra kernel: [ 4599.749155] NOHZ: local_softirq_pending 22
May  9 01:12:51 rudra kernel: [ 4599.750614] NOHZ: local_softirq_pending 22
May  9 01:12:53 rudra kernel: [ 4601.648012] NOHZ: local_softirq_pending 22
May  9 01:12:53 rudra kernel: [ 4601.648457] NOHZ: local_softirq_pending 22
May  9 01:12:53 rudra kernel: [ 4601.648722] NOHZ: local_softirq_pending 22
May  9 01:12:53 rudra kernel: [ 4601.648971] NOHZ: local_softirq_pending 22
May  9 01:12:53 rudra kernel: [ 4601.649217] NOHZ: local_softirq_pending 22
May  9 01:12:53 rudra kernel: [ 4601.649463] NOHZ: local_softirq_pending 22
May  9 01:12:53 rudra kernel: [ 4601.649705] NOHZ: local_softirq_pending 22
May  9 01:12:53 rudra kernel: [ 4601.649951] NOHZ: local_softirq_pending 22
May  9 01:19:16 rudra kernel: [  325.029390] NOHZ: local_softirq_pending 22

TIA
