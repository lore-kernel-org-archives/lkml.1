Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbYA0Wcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbYA0Wcl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 17:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYA0Wcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 17:32:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47319 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbYA0Wcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 17:32:31 -0500
Date: Sun, 27 Jan 2008 23:32:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       vatsa@linux.vnet.ibm.com, Tomasz Chmielewski <mangoo@wpkg.org>,
       linux-kernel@vger.kernel.org, dhaval@linux.vnet.ibm.com
Subject: Re: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
Message-ID: <20080127223218.GA19948@elte.hu>
References: <479B69D2.5050603@wpkg.org> <200801271606.19862.toralf.foerster@gmx.de> <20080127165400.GB1044@linux.vnet.ibm.com> <200801271757.07743.toralf.foerster@gmx.de> <1201469236.6149.7.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1201469236.6149.7.camel@lappy>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Sun, 2008-01-27 at 17:57 +0100, Toralf Förster wrote:
> 
> > It would be nice to run a grid application at lowest priority 
> > without impact to power / fan / temperature but OTOH have full 
> > performance for desktop applications, isn't it ?
> 
> This can be achieved by giving the group/uid the grid application uses 
> a weight of 2.

yes, that's the correct solution. For example, the following line in 
/etc/rc.d/rc.local:

echo 2 > /sys/kernel/uids/`grep -w nobody /etc/passwd | cut -d: -f3`/cpu_share

sets user 'nobody' to a very low cpu weight. If there's any grid user, 
it can be done similarly. The default is 1024.

	Ingo
