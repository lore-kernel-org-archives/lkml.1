Return-Path: <linux-kernel-owner+w=401wt.eu-S1760947AbXJXSZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947AbXJXSZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755290AbXJXSZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:25:29 -0400
Received: from mail.syneticon.net ([213.239.212.131]:35894 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859AbXJXSZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:25:28 -0400
Message-ID: <471F8E10.3090403@wpkg.org>
Date: Wed, 24 Oct 2007 20:25:20 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: james.ausmus@gmail.com
Subject: Re: Possible 2.6.23 regression - Disappearing disk space
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Ausmus wrote:

> As a note - when I first see the issue, I have exactly 0 free space
> available on root, as per df - I then delete some random things in
> order to have enough free space to operate, which is why in my first
> df you see 55M available

Perhaps some program still uses some (deleted) files.

Here's how you can achieve a similar effect manually:

# dd if=/dev/zero of=/file

And on another terminal:

# rm -f /file


Now watch your space decreasing with "df -h", although "the file was 
deleted". Was it really?

# lsof -n|grep /file
dd         6406       root    1w      REG        8,1  807791616 
45 /file (deleted)



That said, you might want to use lsof and search for "deleted" before 
concluding any further.


-- 
Tomasz Chmielewski
http://wpkg.org
