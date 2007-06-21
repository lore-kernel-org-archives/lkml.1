Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbXFUNGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbXFUNGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 09:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbXFUNGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 09:06:36 -0400
Received: from mail.acc.umu.se ([130.239.18.156]:63938 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbXFUNGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 09:06:35 -0400
X-Greylist: delayed 1545 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2007 09:06:35 EDT
Date: Thu, 21 Jun 2007 14:40:44 +0200 (MEST)
From: Mattias Wadenstein <maswan@acc.umu.se>
To: Neil Brown <neilb@suse.de>
cc: David Chinner <dgc@sgi.com>, Avi Kivity <avi@argo.co.il>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
In-Reply-To: <18041.59628.370832.633244@notabene.brown>
Message-ID: <Pine.GSO.4.64.0706211417180.15647@montezuma.acc.umu.se>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
 <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
 <18034.3676.477575.490448@notabene.brown> <467273AB.9010202@argo.co.il>
 <18035.3009.568832.785308@notabene.brown> <20070618045759.GD85884050@sgi.com>
 <18041.59628.370832.633244@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Neil Brown wrote:

> I have that - apparently naive - idea that drives use strong checksum,
> and will never return bad data, only good data or an error.  If this
> isn't right, then it would really help to understand what the cause of
> other failures are before working out how to handle them....

In theory, that's how storage should work. In practice, silent data 
corruption does happen. If not from the disks themselves, somewhere along 
the path of cables, controllers, drivers, buses, etc. If you add in fcal, 
you'll get even more sources of failure, but usually you can avoid SANs 
(if you care about your data).

Well, here is a couple of the issues that I've seen myself:

A hw-raid controller returning every 64th bit as 0, no matter what's on 
disk. With no error condition at all. (I've also heard from a collegue 
about this on every 64k, but not seen that myself.)

An fcal switch occasionally resetting, garbling the blocks in transit with 
random data. Lost a few TB of user data that way.

Add to this the random driver breakage that happens now and then. I've 
also had a few broken filesystems due to in-memory corruption due to bad 
ram, not sure there is much hope of fixing that though.

Also, this presentation is pretty worrying on the frequency of silent data 
corruption:

https://indico.desy.de/contributionDisplay.py?contribId=65&sessionId=42&confId=257

/Mattias Wadenstein
