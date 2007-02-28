Return-Path: <linux-kernel-owner+w=401wt.eu-S1750735AbXB1Ba2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750735AbXB1Ba2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 20:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbXB1Ba2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 20:30:28 -0500
Received: from ns.miraclelinux.com ([219.118.163.66]:40512 "EHLO
	mail01.miraclelinux.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750735AbXB1Ba1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 20:30:27 -0500
Date: Wed, 28 Feb 2007 10:32:39 +0900 (JST)
Message-Id: <20070228.103239.846946216.hyoshiok@miraclelinux.com>
To: hancockr@shaw.ca
Cc: davej@redhat.com, harlan@artselect.com, nickpiggin@yahoo.com.au,
       riel@redhat.com, l_allegrucci@yahoo.it, linux-kernel@vger.kernel.org,
       mingo@elte.hu, suparna@in.ibm.com, jens.axboe@oracle.com,
       hyoshiok@miraclelinux.com
Subject: Re: SMP performance degradation with sysbench
From: Hiro Yoshioka <hyoshiok@miraclelinux.com>
In-Reply-To: <45E4CAC9.4070504@shaw.ca>
References: <fa.RjX9Y4ckjRCle5L+uWNdd0snOio@ifi.uio.no>
	<fa.XocsudxlGplKh0kloTtA0juPwtA@ifi.uio.no>
	<45E4CAC9.4070504@shaw.ca>
X-Mailer: Mew version 3.3 on XEmacs 21.4.13 (Rational FORTRAN)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SMP performance degradation with sysbench
Date: Tue, 27 Feb 2007 18:20:25 -0600
Message-ID: <45E4CAC9.4070504@shaw.ca>

> Hiro Yoshioka wrote:
> > Howdy,
> > 
> > MySQL 5.0.26 had some scalability issues and it solved since 5.0.32
> > http://ossipedia.ipa.go.jp/capacity/EV0612260303/
> > (written in Japanese but you may read the graph. We compared
> > 5.0.24 vs 5.0.32)
> > 
> > The following is oprofile data
> > ==> 
> > cpu=8-mysql=5.0.32-gcc=3.4/oprofile-eu=2200-op=default-none/opreport-l.txt
> > <==
> > CPU: Core Solo / Duo, speed 2666.76 MHz (estimated)
> > Counted CPU_CLK_UNHALTED events (Unhalted clock cycles) with a unit
> > mask of 0x00 (Unhalted core cycles) count 100000
> > samples  %        app name                 symbol name
> > 47097502 16.8391  libpthread-2.3.4.so      pthread_mutex_trylock
> > 19636300  7.0207  libpthread-2.3.4.so      pthread_mutex_unlock
> > 18600010  6.6502  mysqld                   rec_get_offsets_func
> > 18121328  6.4790  mysqld                   btr_search_guess_on_hash
> > 11453095  4.0949  mysqld                   row_search_for_mysql
> > 
> > MySQL tries to get a mutex but it spends about 16.8% of CPU on 8 core
> > machine.
> 
> Curious that it calls pthread_mutex_trylock (as opposed to 
> pthread_mutex_lock) so often. Maybe they're doing some kind of mutex 
> lock busy-looping?

Yes, it is.

Regards,
  Hiro
