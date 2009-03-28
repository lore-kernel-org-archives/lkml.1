Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbZC1Hpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbZC1Hpj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 03:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbZC1Hpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 03:45:30 -0400
Received: from main.gmane.org ([80.91.229.2]:52712 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbZC1Hp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 03:45:29 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bojan Smojver <bojan@rexursive.com>
Subject: Re: Linux 2.6.29
Date: Sat, 28 Mar 2009 07:45:14 +0000 (UTC)
Message-ID: <loom.20090328T073850-695@post.gmane.org>
References: <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090327032301.GN6239@mit.edu> <20090327034705.GA16888@srcf.ucam.org> <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <49CD4109.2070505@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 150.101.121.179 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.8) Gecko/2009032713 Fedora/3.0.8-1.fc10 Firefox/3.0.8)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy <at> goop.org> writes:

> This is a fairly narrow view of correct and possible.  How can you make 
> "cat" fsync? grep? sort?  How do they know they're not dealing with 
> critical data?  Apps in general don't know, because "criticality" is a 
> property of the data itself and how its used, not the tools operating on it.

Isn't it possible to compile a program that simply calls open()/fsync()/close()
on a given file name? If yes, then in your scripts, you can do whatever you want
with existing tools on a _scratch_ file, then call your fsync program on that
scratch file and then rename it to the real file. No?

In other words, given that you know that your data is critical, you will write
processed data to another file, while preserving the original, store the new
file safely and then rename it to the original. Just like the apps that know
that their files are critical are supposed to do using the API.

--
Bojan



