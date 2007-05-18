Return-Path: <linux-kernel-owner+w=401wt.eu-S1763315AbXERVV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763315AbXERVV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbXERVVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:21:51 -0400
Received: from khc.piap.pl ([195.187.100.11]:44750 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbXERVVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:21:50 -0400
To: "Anand Jahagirdar" <anandjigar@gmail.com>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       linux-kernel@vger.kernel.org, "Coywolf Qi Hunt" <coywolf@sosdg.org>
Subject: Re: Fork Bombing Attack
References: <25ae38200705170745t4a80e7eer413b3c2bb0c5a327@mail.gmail.com>
	<4051.1179414105@turing-police.cc.vt.edu>
	<25ae38200705180413s741cac1bw9fe0dc57cecc2a91@mail.gmail.com>
	<1865922a0705180619g2a997c2ch5d13be3e023630e0@mail.gmail.com>
	<25ae38200705181022l35e0b364p98fc39e5739612b@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 18 May 2007 23:21:49 +0200
In-Reply-To: <25ae38200705181022l35e0b364p98fc39e5739612b@mail.gmail.com> (Anand Jahagirdar's message of "Fri, 18 May 2007 22:52:15 +0530")
Message-ID: <m31whdg74i.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Anand Jahagirdar" <anandjigar@gmail.com> writes:

> ulimit are by default  set to some value for all users.. root, guest.
> on my machine with FC4 distribution when i typed command "ulimit -u"
> it gave me output as 3055 and another machine having FC6 distribution
> output is 8050. when root or any other user changes ulimit by typing
> "ulimit -u value",.ulimit value is changed for that session and not
> permantely. actually ulimit should help to prevent fork bombing attack
> but it wont and fork bombing attack still take down the machine having
> latest linux distributions.

how about:
$ ulimit -u 100
$ for f in `seq 1 500`; do (sleep 100&); done

(on another terminal)
$ ps xa|grep 'sleep 100' |wc -l

mine prints 93.
-- 
Krzysztof Halasa
