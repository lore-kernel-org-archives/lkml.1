Return-Path: <linux-kernel-owner+w=401wt.eu-S1761824AbYENILM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761824AbYENILM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 04:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYENIKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 04:10:47 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:51909 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758148AbYENIKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 04:10:44 -0400
Date: Wed, 14 May 2008 12:10:29 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Florian Wiessner <ich@netz-guru.de>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Transactions, failover, performance.
Message-ID: <20080514081029.GA16134@2ka.mipt.ru>
References: <20080513174523.GA1677@2ka.mipt.ru> <4829E752.8030104@garzik.org> <20080513205114.GA16489@2ka.mipt.ru> <20080514005223.GE27483@shareable.org> <482A3D88.2060105@netz-guru.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482A3D88.2060105@netz-guru.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, May 14, 2008 at 03:16:56AM +0200, Florian Wiessner (ich@netz-guru.de) wrote:
> I am currently working on mysqlfs which is a fuse fs which can be used 
> in conjunction with mysql-ndb cluster.
> 
> You can find the details here: http://sourceforge.net/projects/mysqlfs/
> and a howto (in german, though) here: 
> http://www.netz-guru.de/2008/04/03/mysqlfs-mit-mysql-ndb-cluster-als-verteiltes-dateisystem/
> 
> It is working quite well, but still lacks of caching which makes it slow
> if your connection between the DB-servers have high latency/many hops.

Did FUSE start to make a fiendship with performance? Last time I saw it,
they hated each other...

Caching actually useful not only on slow, but also very fast links
because of its ability to batch data and greatly reduce latencies of
reply-request protocols, which in turn (for that protocols) greatly
increases performance. If you are using async processing (like POHMELFS,
iirc it is the only such approach in networked fs, cifs/smbfs and others
wait after request is sent and only then proceed with the next one) that
will allow to drain the cache very quickly and proceed with the next
data set.

-- 
	Evgeniy Polyakov
