Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbXLFJ2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbXLFJ2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 04:28:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbXLFJ2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 04:28:37 -0500
Received: from main.gmane.org ([80.91.229.2]:44591 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbXLFJ2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 04:28:36 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger@wizards.de>
Subject: Re: Reproducible data corruption with sendfile+vsftp - splice regression?
Date: Thu, 06 Dec 2007 10:28:09 +0100
Organization: The Fists of the White Lotus
Message-ID: <pan.2007.12.06.09.28.08.913625@wizards.de>
References: <pan.2007.11.29.23.42.52.661624@wizards.de> <474FC4D9.3020506@cosmosbay.com> <pan.2007.11.30.09.20.24.737500@wizards.de> <475055EE.9060105@hp.com> <pan.2007.12.02.16.00.03.568000@wizards.de> <pan.2007.12.02.20.49.42.675000@wizards.de> <20071205225429.GA10186@electric-eye.fr.zoreil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: port-87-234-135-174.dynamic.qsc.de
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 05 Dec 2007 23:54:29 +0100, Francois Romieu wrote:

> Holger Hoffstaette <holger@wizards.de> : [...]
>> Should I file this in bugzilla?
> 
> Yes.

Thanks for responding - will do. I verified with 2.6.24-rc4 (same bug) and
have some new information about this.
Despite my previous posting the corruption is NOT triggered by NAPI. It
may be related, but even without NAPI but tso on again I got corruption,
now also on the gbit client (Thinkpad T60). When ftp'ing to ramdisk with
full speed (at a reasonable ~77 MB/sec) it "often" works, but intermediate
writes that cause the ftp to temporarily slow down reliably cause
corrupted files, so I guess tso gets confused when some kind of throttling
sets in during transfer. That is probably why I first noticed it on the
slow 100mbit client.
Maybe turning off sendfile or NAPI just lead to random success - so far it
really looks like tso on the r8169 is the common cause.

thank you
Holger


