Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbZKVM1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbZKVM1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbZKVM1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:27:40 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53714 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751845AbZKVM1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:27:39 -0500
Date: Sun, 22 Nov 2009 12:29:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: swan.r.l@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [bisected] pty performance problem
Message-ID: <20091122122942.644006fb@lxorguk.ukuu.org.uk>
In-Reply-To: <20091122002748.GA6605@swanrl.gmail.com>
References: <20091121222319.GA3905@swanrl.gmail.com>
	<20091121232320.3262636c@lxorguk.ukuu.org.uk>
	<20091122002748.GA6605@swanrl.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> While I could rewrite the communications to optionally use pipes, or
> get the client to reprocess a log file locally, what I have does seem
> a reasonable use of ptys.

Wouldn't argue with that. The tty layer queues the characters which then
get processed but at the moment get processed after the next timer tick
not when the CPU is idle. That wants changing and it strikes me as utterly
dumb in general to be deferring work when the CPU is idle.

Alan

