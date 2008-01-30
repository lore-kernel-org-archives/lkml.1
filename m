Return-Path: <linux-kernel-owner+w=401wt.eu-S1759656AbYA3KV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656AbYA3KV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759264AbYA3KUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:20:45 -0500
Received: from trinity.phys.uwm.edu ([129.89.57.159]:46453 "EHLO
	trinity.phys.uwm.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759111AbYA3KUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:20:42 -0500
X-Greylist: delayed 1718 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jan 2008 05:20:42 EST
Date: Wed, 30 Jan 2008 03:51:51 -0600 (CST)
From: Bruce Allen <ballen@gravity.phys.uwm.edu>
X-X-Sender: ballen@trinity.phys.uwm.edu
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Henning Fehrmann <henning.fehrmann@aei.mpg.de>,
       Carsten Aulbert <carsten.aulbert@aei.mpg.de>,
       Bruce Allen <bruce.allen@aei.mpg.de>
Subject: e1000 full-duplex TCP performance well below wire speed
Message-ID: <Pine.LNX.4.63.0801300324000.6391@trinity.phys.uwm.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear LKML,

We've connected a pair of modern high-performance boxes with integrated 
copper Gb/s Intel NICS, with an ethernet crossover cable, and have run 
some netperf full duplex TCP tests.  The transfer rates are well below 
wire speed.  We're reporting this as a kernel bug, because we expect a 
vanilla kernel with default settings to give wire speed (or close to wire 
speed) performance in this case. We DO see wire speed in simplex 
transfers. The behavior has been verified on multiple machines with 
identical hardware.

Details:
Kernel version: 2.6.23.12
ethernet NIC: Intel 82573L
ethernet driver: e1000 version 7.3.20-k2
motherboard: Supermicro PDSML-LN2+ (one quad core Intel Xeon X3220, Intel 
3000 chipset, 8GB memory)

The test was done with various mtu sizes ranging from 1500 to 9000, with 
ethernet flow control switched on and off, and using reno and cubic as a 
TCP congestion control.

The behavior depends on the setup. In one test we used cubic congestion 
control, flow control off. The transfer rate in one direction was above 
0.9Gb/s while in the other direction it was 0.6 to 0.8 Gb/s. After 15-20s 
the rates flipped. Perhaps the two steams are fighting for resources. (The 
performance of a full duplex stream should be close to 1Gb/s in both 
directions.)  A graph of the transfer speed as a function of time is here: 
https://n0.aei.uni-hannover.de/networktest/node19-new20-noflow.jpg
Red shows transmit and green shows receive (please ignore other plots):

We're happy to do additional testing, if that would help, and very 
grateful for any advice!

Bruce Allen
Carsten Aulbert
Henning Fehrmann
