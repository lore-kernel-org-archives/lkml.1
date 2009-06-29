Return-Path: <linux-kernel-owner+w=401wt.eu-S1757388AbZF2Rih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbZF2Rih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 13:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbZF2Ri0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 13:38:26 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:44727 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbZF2Ri0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 13:38:26 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 29 Jun 2009 10:36:30 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Jarek Poplawski <jarkao2@gmail.com>
cc: Jiri Olsa <jolsa@redhat.com>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fbl@redhat.com, nhorman@redhat.com, davem@redhat.com, htejun@gmail.com,
       oleg@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH 1/2] net: adding memory barrier to the poll and receive
 callbacks
In-Reply-To: <20090629173217.GC2742@ami.dom.local>
Message-ID: <alpine.DEB.1.10.0906291033140.30244@makko.or.mcafeemobile.com>
References: <20090629140434.GE3845@jolsa.lab.eng.brq.redhat.com> <20090629141445.GF3845@jolsa.lab.eng.brq.redhat.com> <alpine.DEB.1.10.0906290826300.29966@makko.or.mcafeemobile.com> <20090629173217.GC2742@ami.dom.local>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009, Jarek Poplawski wrote:

> > I think Oleg already said this, but you can use directly poll_wait() 
> > without adding another abstraction, and the compiler will drop the double 
> > check for you:
> 
> I think Oleg told about cosmetics and let Jiri to choose. I'd only
> add it's not mainly about optimization, but easy showing the main
> difference, of course depending on taste.

We already have a universally used function to do that, and that's 
poll_wait().
That code (adding an extra __poll_wait()) was entirely about 
optimizations (otherwise why not use the existing poll_wait()?), so if 
the optimization does not actually take place, IMO it's better to not add 
an extra API.



- Davide


