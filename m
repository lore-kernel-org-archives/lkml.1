Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbYHCNNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbYHCNNl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 09:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbYHCNNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 09:13:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39657 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754526AbYHCNNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 09:13:34 -0400
Date: Sun, 3 Aug 2008 13:56:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Brian Beattie <beattie@beattie-home.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ioctl's suck?
Message-ID: <20080803135622.7f624327@lxorguk.ukuu.org.uk>
In-Reply-To: <1217714096.6280.35.camel@kokopelli>
References: <1217714096.6280.35.camel@kokopelli>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I could add a control device and pass ascii strings for status and OOB
> messages, would that be an improvement?

Usually not. The idea that ioctl can be replaced with ascii messages is
clueless rubbish that generally gets spouted by people with their head
in the clouds of conceptual elegance and no grasp of reality.

There are certain things you can expose that way usefully via sysfs
- things like general stateless status information. Ioctl however provides
an interface tied to file handle not name (which is essential in a hotplug
environment) and an ordering to events so you know the response you get
matches the query you made.

There are good things to do with ioctls:
- Make sure the size of all the fields are consistent across 32/64bit
(for 32bit binaries on 64bit)
- Use the IOR/IOW/IORW macros

Alan
