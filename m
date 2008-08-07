Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbYHGQqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbYHGQqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 12:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbYHGQqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 12:46:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34378 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYHGQqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 12:46:43 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <489B26F0.3030603@s5r6.in-berlin.de>
Date: Thu, 07 Aug 2008 18:46:40 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] mdb-2.6.27-rc2-ia32-08-07-08.patch
References: <1300.69.2.248.210.1218119365.squirrel@webmail.wolfmountaingroup.com>    <489B199B.40305@s5r6.in-berlin.de>    <489B1BDC.1010504@s5r6.in-berlin.de> <1923.69.2.248.210.1218124570.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <1923.69.2.248.210.1218124570.squirrel@webmail.wolfmountaingroup.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com wrote:
> rspin locks are for these types of cases -- so if I fault on the same
> processor I took the lock on it just bumps a counter -- yes, it is atomic
> and SMP safe to do it this way.

Only if all contexts which take rlocks are not preemptible.  Which I 
don't know whether they are; I'm just a driver guy.  You use 
spin_lock_irqsave() rather than plain spin_lock() though, which 
indicates that you want to be able to take the locks from preemptible 
contexts too.  In that case, your accessors are subtly buggy.
-- 
Stefan Richter
-=====-==--- =--- --===
http://arcgraph.de/sr/
