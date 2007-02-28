Return-Path: <linux-kernel-owner+w=401wt.eu-S1750994AbXB1AYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994AbXB1AYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 19:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbXB1AYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 19:24:31 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:5448 "EHLO
	pd5mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbXB1AYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 19:24:30 -0500
Date: Tue, 27 Feb 2007 18:20:25 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SMP performance degradation with sysbench
In-reply-to: <fa.XocsudxlGplKh0kloTtA0juPwtA@ifi.uio.no>
To: hyoshiok@miraclelinux.com
Cc: Dave Jones <davej@redhat.com>, Pete Harlan <harlan@artselect.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Rik van Riel <riel@redhat.com>,
       Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Message-id: <45E4CAC9.4070504@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.V3M3ZgXL+lFlIyhx43YxCU/JFUk@ifi.uio.no>
 <fa.ciL5lzdfskdJHJPgn+UVCHt/9EM@ifi.uio.no>
 <fa.2ABbHhyCbp3Fx7hSE/Gr0SuzFvw@ifi.uio.no>
 <fa.oaZk6Aiqd8gyZNsj7+m+w9MibhU@ifi.uio.no>
 <fa.RjX9Y4ckjRCle5L+uWNdd0snOio@ifi.uio.no>
 <fa.XocsudxlGplKh0kloTtA0juPwtA@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hiro Yoshioka wrote:
> Howdy,
> 
> MySQL 5.0.26 had some scalability issues and it solved since 5.0.32
> http://ossipedia.ipa.go.jp/capacity/EV0612260303/
> (written in Japanese but you may read the graph. We compared
> 5.0.24 vs 5.0.32)
> 
> The following is oprofile data
> ==> 
> cpu=8-mysql=5.0.32-gcc=3.4/oprofile-eu=2200-op=default-none/opreport-l.txt
> <==
> CPU: Core Solo / Duo, speed 2666.76 MHz (estimated)
> Counted CPU_CLK_UNHALTED events (Unhalted clock cycles) with a unit
> mask of 0x00 (Unhalted core cycles) count 100000
> samples  %        app name                 symbol name
> 47097502 16.8391  libpthread-2.3.4.so      pthread_mutex_trylock
> 19636300  7.0207  libpthread-2.3.4.so      pthread_mutex_unlock
> 18600010  6.6502  mysqld                   rec_get_offsets_func
> 18121328  6.4790  mysqld                   btr_search_guess_on_hash
> 11453095  4.0949  mysqld                   row_search_for_mysql
> 
> MySQL tries to get a mutex but it spends about 16.8% of CPU on 8 core
> machine.

Curious that it calls pthread_mutex_trylock (as opposed to 
pthread_mutex_lock) so often. Maybe they're doing some kind of mutex 
lock busy-looping?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

