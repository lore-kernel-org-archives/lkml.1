Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZAMWmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZAMWmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbZAMWmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:42:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55530
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752265AbZAMWmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:42:07 -0500
Date: Tue, 13 Jan 2009 14:42:08 -0800 (PST)
Message-Id: <20090113.144208.151478270.davem@davemloft.net>
To: Jesper.Nilsson@axis.com
Cc: tj@kernel.org, gregkh@suse.de, stern@rowland.harvard.edu,
       jens.axboe@oracle.com, hinko.kocevar@cetrtapot.si,
       linux-kernel@vger.kernel.org
Subject: Re: lib/klist.c: bit 0 in pointer can't be used as flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090113221235.GD19262@axis.com>
References: <20090113151406.GC19262@axis.com>
	<20090113.131030.207355839.davem@davemloft.net>
	<20090113221235.GD19262@axis.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Nilsson <Jesper.Nilsson@axis.com>
Date: Tue, 13 Jan 2009 23:12:35 +0100

> Can you recall another place where this trick is used?
> 
> It seems that rt_mutex uses the same trick (with the lowest 2bits)
> but AFAICT that's something we don't use on CRIS.

Sparsemem uses it.

The TRIE based routing tables uses it.

All of the IPV4/IPV6 socket hash tables use it as of 2.6.29-rc1.

You really can't avoid supporting this.  Why doesn't kmalloc
return properly aligned objects on CRIS?
