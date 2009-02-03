Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbZBCWQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbZBCWQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 17:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbZBCWQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 17:16:22 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:48292 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZBCWQV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 17:16:21 -0500
X-Greylist: delayed 1198 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Feb 2009 17:16:21 EST
Message-ID: <4988BD4E.8080206@cosmosbay.com>
Date: Tue, 03 Feb 2009 22:55:26 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, oleg@redhat.com, viro@ZenIV.linux.org.uk,
       davidel@xmailserver.org, davem@davemloft.net, hch@lst.de,
       linux-api@vger.kernel.org, mpm@selenic.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
References: <1233598811-6871-1-git-send-email-corbet@lwn.net>	<1233598811-6871-3-git-send-email-corbet@lwn.net> <20090203133942.2ecec281.akpm@linux-foundation.org>
In-Reply-To: <20090203133942.2ecec281.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 03 Feb 2009 22:55:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton a écrit :
> On Mon,  2 Feb 2009 11:20:09 -0700
> Jonathan Corbet <corbet@lwn.net> wrote:
> 
>> Matt Mackall suggested converting epoll's ep_lock to a bitlock as a way of
>> saving space in struct file.  This patch makes that change.
> 
> hrm.  bit_spin_lock() makes people upset (large penguiny people).  iirc
> it doesn't have all the correct/well-understood memory/compiler
> ordering semantics which spinlocks have.  And lockdep doesn't know about
> it.
> 

In a previous attempt (2005), I suggested using a single global lock.

http://search.luky.org/linux-kernel.2005/msg50862.html

Probably an array of hashed spinlocks would be more than enough.



