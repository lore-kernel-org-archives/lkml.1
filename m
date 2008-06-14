Return-Path: <linux-kernel-owner+w=401wt.eu-S1759158AbYFNJt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158AbYFNJt3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 05:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756471AbYFNJtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 05:49:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56546 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972AbYFNJtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 05:49:16 -0400
Message-ID: <48539410.30804@garzik.org>
Date: Sat, 14 Jun 2008 05:49:04 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: Jamie Lokier <jamie@shareable.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [2/3] POHMELFS: Documentation.
References: <20080613163700.GA25860@2ka.mipt.ru> <20080613164110.GB26166@2ka.mipt.ru> <20080614021547.GC32232@shareable.org> <20080614065616.GA32585@2ka.mipt.ru>
In-Reply-To: <20080614065616.GA32585@2ka.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> Oplocks and leases are essentially lock on given file, which allows one
> client to operate on it. POHMELFS does not have locks now, and they will
> be created depending on how distributed server will require them. In the
> simplesst case it can just lock file for writing and do not allow its
> updates from other clients. Lock aciquite can be done at write_begin
> time. Without lock and writeback cache in your case writeback for file Y
> can happen before writeback for file X, but if client does not only
> write, but also sync after its write, then yes, client will see later
> updates after more earlier. POHMELFS does not broadcast its interest in
> the file content until real writing happens, i.e. at writeback time.
> Although I can add a mode, when the same will be done during
> write_begin() time. In that case your example will work without sync.


For /locking/, life is easy, you don't have to worry about disallowing 
client updates, because locking is advisory.  However, there are some 
guarantees you need for locking WRT write commit, and of course leases 
are a totally different animal where you do block client updates.

	Jeff


