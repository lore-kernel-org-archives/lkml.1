Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536AbXCRXpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbXCRXpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 19:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbXCRXpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 19:45:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63486 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbXCRXpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 19:45:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [patch 2/13] signal/timer/event fds v6 - signalfd core ...
Date: Mon, 19 Mar 2007 00:45:23 +0100
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
References: <send-serie.davidel@xmailserver.org.9367.1174004536.2> <200703172235.09227.arnd@arndb.de> <Pine.LNX.4.64.0703181313460.5482@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0703181313460.5482@alien.or.mcafeemobile.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703190045.24605.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/hDqiiQVMuW8qfzA0VPWnmpjzg3W4vFnTJjVx
 ygFqmWQNJ1eIX9wtDAxEfK9th2N0TnchVqzOBxwFosTDV5Tdw2
 hw1oQZogbrAqdgSbDLK2g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 March 2007, Davide Libenzi wrote:
> bah, __put_user is basically a move, so I don't think that efficency would 
> be that different (assuming that it'd matter in this case). The only thing 
> many __put_user do, is increase the exception table sizes.

The cost of user access functions varies a lot depending on the
architectures. Those platforms with a 4G/4G split e.g. need to do more
than a simple move, and for s390 it may even come down to an indirect
function call, which incurs significant register pressure.

	Arnd <><
