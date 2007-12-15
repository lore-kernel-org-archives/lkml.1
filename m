Return-Path: <linux-kernel-owner+w=401wt.eu-S1759635AbXLOKOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbXLOKOU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 05:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbXLOKOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 05:14:04 -0500
Received: from yumi.tdiedrich.de ([85.10.210.183]:53657 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbXLOKOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 05:14:01 -0500
Date: Sat, 15 Dec 2007 11:08:58 +0100
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org,
       dada1@cosmosbay.com
Subject: Re: dst cache overflow
Message-ID: <20071215100857.GA29839@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, linux-net@vger.kernel.org,
	linux-kernel@vger.kernel.org, dada1@cosmosbay.com
References: <20071214172945.GA10809@yamamaya.is-a-geek.org> <E1J3QWn-0006sJ-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1J3QWn-0006sJ-00@gondolin.me.apana.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> Tobias Diedrich <ranma+kernel@tdiedrich.de> wrote:
> >
> > Meanwhile I added a slab statistic rrd script. Nothing obvious to
> > see on ari or yumi yet, but on oni (which after all is the most
> > affected by this) I can see 'size_2048' and 'TCPv6' growing
> > steadily along with the route cache size (Presumably 'ip_dst_cache',
> > which is also growing larger at a more or less constant rate).
> 
> OK that almost certainly means that we have a leak of TCPv6
> objects which would then cause a leak of dst objects.
> 
> So you need to track down why TCPv6 isn't getting cleaned up.
> First check the obvious, do you have any process(es) that are
> hoarding TCPv6 sockets?

Hmm, how do I look for that, if netstat doesn't look suspicous?

> If not do you see a growing list of dead sockets in netstat?

No, I don't think so.

oni:~# netstat -an | wc -l
139
oni:~# netstat -tun
Active Internet connections (w/o servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 217.172.187.75:53668    xx.xxx.xx.x:6543        ESTABLISHED
tcp        0      0 217.172.187.75:40180    yyy.yyy.yyy.yy:6871     TIME_WAIT  
tcp        0      0 217.172.187.75:58480    xx.xxx.xx.x:6543        ESTABLISHED
tcp        0      0 217.172.187.75:49213    xx.xxx.xx.x:6543        ESTABLISHED
tcp        0      0 217.172.187.75:34828    xx.xxx.xx.x:6543        ESTABLISHED
tcp        0      0 217.172.187.75:44859    xx.xxx.xx.x:6543        ESTABLISHED
tcp        0      0 217.172.187.75:41863    xx.xxx.xx.x:6543        ESTABLISHED
tcp        0      0 217.172.187.75:38063    xx.xxx.xx.x:6543        ESTABLISHED
tcp6       0      0 ::ffff:217.172.187.7:80 ::ffff:zz.zzz.zz.z:3729 TIME_WAIT  
tcp6       0      0 ::ffff:217.172.187.7:80 ::ffff:zz.zzz.zz.z:3726 TIME_WAIT  
tcp6       0      0 ::ffff:217.172.187.7:80 ::ffff:aa.aa.aaa.:59396 ESTABLISHED
tcp6       0    992 ::ffff:217.172.187.7:22 ::ffff:bb.bbb.bb.:57870 ESTABLISHED

HTH,

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
