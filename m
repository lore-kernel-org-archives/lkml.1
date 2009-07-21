Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbZGURb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbZGURb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 13:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbZGURbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 13:31:53 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:57893 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbZGURbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 13:31:52 -0400
From: Frans Pop <elendil@planet.nl>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [2.6.30.1] Significant latency playing video file from NFS4 share
Date: Tue, 21 Jul 2009 19:31:48 +0200
User-Agent: KMail/1.9.9
Cc: linux-nfs@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
References: <200907172250.51504.elendil@planet.nl> <1247871086.4945.38.camel@heimdal.trondhjem.org> <200907180131.12586.elendil@planet.nl>
In-Reply-To: <200907180131.12586.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200907211931.50015.elendil@planet.nl>
X-OriginalArrivalTime: 21 Jul 2009 17:31:50.0756 (UTC) FILETIME=[21A02240:01CA0A29]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n6LHWYJ7007306

Any suggestions based on the data below?
Is the problem maybe that the amount of data transferred each time is sobig that the network speed becomes a bottleneck and causes the latency?I can reproduce the issue with both a 10MBit wired link and with a 54MBitwireless link.
Is this a kernel bug or a configuration issue?
Thanks,FJP
On Saturday 18 July 2009, Frans Pop wrote:> Thanks for the quick response!>> On Saturday 18 July 2009, Trond Myklebust wrote:> > Have you tried running nfs-iostat from the nfs-utils package to try> > and figure out what the latency is on each READ request from the> > client?> >> > You need to run something like> >> >     nfs-iostat --page 20 10 /src/<mountpoint>> >> > while running the vlc app.
$ ../nfs-iostat.py --page 20 10 /srv/fjp/david
Note:The mount point selection could be improved. I first had a trailing slashafter the mount point and that resulted in all mounts being included in theoutput. Removing the slash helped.
elrond:/david mounted on /srv/fjp/david:
   op/s         rpc bklog   0.65            0.00read:             ops/s            kB/s           kB/op         retrans         avg RTT (ms)    avg exe (ms)                  0.406         101.661         250.613        0 (0.0%)         1211.745        1222.640write:            ops/s            kB/s           kB/op         retrans         avg RTT (ms)    avg exe (ms)                  0.000           0.000           0.000        0 (0.0%)           0.000           0.000
13 nfs_readpage() calls read 13 pages1417 nfs_readpages() calls read 971428 pages (685.6 pages per call)
0 nfs_updatepage() calls0 nfs_writepage() calls wrote 0 pages18760 nfs_writepages() calls wrote 0 pages (0.0 pages per call)
elrond:/david mounted on /srv/fjp/david:
   op/s         rpc bklog   0.25            0.00read:             ops/s            kB/s           kB/op         retrans         avg RTT (ms)    avg exe (ms)                  0.100           0.426           4.262        0 (0.0%)           6.000           6.000write:            ops/s            kB/s           kB/op         retrans         avg RTT (ms)    avg exe (ms)                  0.000           0.000           0.000        0 (0.0%)           0.000           0.000
0 nfs_readpage() calls read 0 pages2 nfs_readpages() calls read 2 pages (1.0 pages per call)
0 nfs_updatepage() calls0 nfs_writepage() calls wrote 0 pages6 nfs_writepages() calls wrote 0 pages (0.0 pages per call)
elrond:/david mounted on /srv/fjp/david:
   op/s         rpc bklog   0.80            0.00read:             ops/s            kB/s           kB/op         retrans         avg RTT (ms)    avg exe (ms)                  0.750         192.196         256.262        0 (0.0%)         1998.933        1999.200write:            ops/s            kB/s           kB/op         retrans         avg RTT (ms)    avg exe (ms)                  0.000           0.000           0.000        0 (0.0%)           0.000           0.000
0 nfs_readpage() calls read 0 pages1 nfs_readpages() calls read 960 pages (960.0 pages per call)
0 nfs_updatepage() calls0 nfs_writepage() calls wrote 0 pages6 nfs_writepages() calls wrote 0 pages (0.0 pages per call)
elrond:/david mounted on /srv/fjp/david:
   op/s         rpc bklog   0.00            0.00read:             ops/s            kB/s           kB/op         retrans         avg RTT (ms)    avg exe (ms)                  0.000           0.000           0.000        0 (0.0%)           0.000           0.000write:            ops/s            kB/s           kB/op         retrans         avg RTT (ms)    avg exe (ms)                  0.000           0.000           0.000        0 (0.0%)           0.000           0.000
0 nfs_readpage() calls read 0 pages0 nfs_readpages() calls read 0 pages
0 nfs_updatepage() calls0 nfs_writepage() calls wrote 0 pages6 nfs_writepages() calls wrote 0 pages (0.0 pages per call)
elrond:/david mounted on /srv/fjp/david:
   op/s         rpc bklog   0.85            0.00read:             ops/s            kB/s           kB/op         retrans         avg RTT (ms)    avg exe (ms)                  0.750         192.196         256.262        0 (0.0%)         1927.467        1927.467write:            ops/s            kB/s           kB/op         retrans         avg RTT (ms)    avg exe (ms)                  0.000           0.000           0.000        0 (0.0%)           0.000           0.000
0 nfs_readpage() calls read 0 pages1 nfs_readpages() calls read 960 pages (960.0 pages per call)
0 nfs_updatepage() calls0 nfs_writepage() calls wrote 0 pages6 nfs_writepages() calls wrote 0 pages (0.0 pages per call)
elrond:/david mounted on /srv/fjp/david:
   op/s         rpc bklog   0.00            0.00read:             ops/s            kB/s           kB/op         retrans         avg RTT (ms)    avg exe (ms)                  0.000           0.000           0.000        0 (0.0%)           0.000           0.000write:            ops/s            kB/s           kB/op         retrans         avg RTT (ms)    avg exe (ms)                  0.000           0.000           0.000        0 (0.0%)           0.000           0.000
0 nfs_readpage() calls read 0 pages0 nfs_readpages() calls read 0 pages
0 nfs_updatepage() calls0 nfs_writepage() calls wrote 0 pages6 nfs_writepages() calls wrote 0 pages (0.0 pages per call)
elrond:/david mounted on /srv/fjp/david:
   op/s         rpc bklog   0.85            0.00read:             ops/s            kB/s           kB/op         retrans         avg RTT (ms)    avg exe (ms)                  0.750         192.196         256.262        0 (0.0%)         1930.933        1931.467write:            ops/s            kB/s           kB/op         retrans         avg RTT (ms)    avg exe (ms)                  0.000           0.000           0.000        0 (0.0%)           0.000           0.000
0 nfs_readpage() calls read 0 pages1 nfs_readpages() calls read 960 pages (960.0 pages per call)
0 nfs_updatepage() calls0 nfs_writepage() calls wrote 0 pages5 nfs_writepages() calls wrote 0 pages (0.0 pages per call)
elrond:/david mounted on /srv/fjp/david:
   op/s         rpc bklog   0.15            0.00read:             ops/s            kB/s           kB/op         retrans         avg RTT (ms)    avg exe (ms)                  0.100           0.426           4.262        0 (0.0%)           6.000           6.000write:            ops/s            kB/s           kB/op         retrans         avg RTT (ms)    avg exe (ms)                  0.000           0.000           0.000        0 (0.0%)           0.000           0.000
0 nfs_readpage() calls read 0 pages2 nfs_readpages() calls read 2 pages (1.0 pages per call)
0 nfs_updatepage() calls0 nfs_writepage() calls wrote 0 pages6 nfs_writepages() calls wrote 0 pages (0.0 pages per call)���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
