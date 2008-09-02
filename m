Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbYIBCLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbYIBCLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 22:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYIBCLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 22:11:43 -0400
Received: from smtp.regionline.fi ([85.157.255.99]:48249 "EHLO
	smtp.regionline.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbYIBCLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 22:11:43 -0400
X-Greylist: delayed 1081 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Sep 2008 22:11:42 EDT
From: Jan Knutar <jknutar@nic.fi>
To: "J.A. =?iso-8859-1?q?Magall=F3n?=" <jamagallon@ono.com>
Subject: Re: Finding what is stuck...
Date: Tue, 2 Sep 2008 04:53:35 +0300
User-Agent: KMail/1.9.9
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
References: <20080902020447.5b48b083@one.home>
In-Reply-To: <20080902020447.5b48b083@one.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809020453.36396.jknutar@nic.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 September 2008, J.A. Magallón wrote:

> I'm running 2.6.27-rc5-git2 on an Aspire One.
> The system is in general pretty responsive, but sometimes it just
> gets totally stuck. Even the mouse stops.
>
> It looks related to disk (SSD) access, but I'm not totally sure.

Are you hitting swap at all? Does it have swap?

On my N810 tablet there can be a huge slowdown if it starts swapping. 
The first time it dips into swap is relatively painless when stuff gets 
written out sequentially, but after that when writes are mostly random 
the throughput drops to a few kilobytes per second, causing massive 
slowdown... The MMC/SD cards hate random write, and I expect SSDs are 
no better.

iostat -x -k 10
in a terminal is useful. Check the iowait and util% numbers after/during 
slowdown...
