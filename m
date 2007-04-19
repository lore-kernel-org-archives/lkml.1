Return-Path: <linux-kernel-owner+w=401wt.eu-S2993235AbXDSLwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993235AbXDSLwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 07:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993243AbXDSLwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 07:52:10 -0400
Received: from bill.weihenstephan.org ([82.135.35.21]:43660 "EHLO
	bill.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993235AbXDSLwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 07:52:09 -0400
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: linux-kernel@vger.kernel.org
Subject: Re: Wrong free clusters count on FAT32
Date: Thu, 19 Apr 2007 13:52:05 +0200
User-Agent: KMail/1.9.4
Cc: DervishD <lkml@dervishd.net>
References: <20070419085750.GA2833@DervishD>
In-Reply-To: <20070419085750.GA2833@DervishD>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704191352.06456.juergen127@kreuzholzen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 April 2007 10:57, DervishD wrote:
>     I have a portable device with a FAT32 formatted hard disk in it, and
> everytime I delete a file in the device *using the device itself to do
> it* the device increases its count of free space and if I plug the
> device in a Windows system, Windows agrees on the free space. Linux
> doesn't. Linux believes that the files are still there ocuppying space,
> and I have to run fsck.vfat to fix the problem.

As I remember: It needs a large amount of time to calculate the free space on 
a big FAT32 system. So the last free sector count is also stored. When 
mounting this filesystem you don't need to walk through the whole FAT to 
calculate the available space, you can use this "cached" value instead. And 
this cached value seems not to be updated in your portable device.

Maybe it helps, but maybe I'm wrong.

Juergen
