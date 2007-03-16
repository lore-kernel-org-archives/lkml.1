Return-Path: <linux-kernel-owner+w=401wt.eu-S965292AbXCPOpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292AbXCPOpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 10:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965371AbXCPOpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 10:45:06 -0400
Received: from poczta.o2.pl ([193.17.41.142]:45240 "EHLO poczta.o2.pl"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965292AbXCPOpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 10:45:04 -0400
Date: Fri, 16 Mar 2007 15:49:22 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Neil Brown <neilb@suse.de>
Subject: Re: [2.6.20] BUG: workqueue leaked lock
Message-ID: <20070316144921.GB5877@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315191749.GS31960@vanheusden.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-03-2007 20:17, Folkert van Heusden wrote:
>>> On Tue, 13 Mar 2007 17:50:14 +0100 Folkert van Heusden <folkert@vanheusden.com> wrote:
>>> ...
>>> [ 1756.728209] BUG: workqueue leaked lock or atomic: nfsd4/0x00000000/3577
> ...
>>> [ 1846.684023]  [<c1003bdb>] kernel_thread_helper+0x7/0x10
>> Oleg, that's a fairly incomprehensible message we have in there.  Can you
>> please explain what it means?
> 
> Haha ok :-)
> 
> Good, since I run 2.6.20 with these debugging switches switched on, I
> get occasionally errors like these. I get ALWAYS the following error
> when the system first boots when the TOR executable is started:
> 
> [  137.324255] =======================================================
> [  137.324359] [ INFO: possible circular locking dependency detected ]
> [  137.324412] 2.6.20 #2
> [  137.324457] -------------------------------------------------------

Hi,

IMHO you should now switch off lockdep ("Lock debuging: ..." options),
until you update or get some patch for this circular problem.  Your
logs should be sufficient to nfsd people and lockdep turns off checking
after this anyway. I don't know if this is a known and real locking
problem, but it could be interesting now, if workqueue error would
reapear. It seems nfsd code is breaking somewhere with locks held -
maybe because of problems with lockdep's error handling.

Regards,
Jarek P.

