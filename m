Return-Path: <linux-kernel-owner+w=401wt.eu-S1765068AbXJPDlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765068AbXJPDlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 23:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764790AbXJPDk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 23:40:57 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:37235 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764738AbXJPDkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 23:40:55 -0400
X-Greylist: delayed 1521 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Oct 2007 23:40:55 EDT
Message-ID: <jwvwstnsqds.fsf-monnier+inbox@gnu.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Killing a network connection
References: <jwvodf01b5i.fsf-monnier+gmane.linux.kernel@gnu.org>
	<p73przg10yp.fsf@bingen.suse.de>
From: Stefan Monnier <monnier@iro.umontreal.ca>
Date: Mon, 15 Oct 2007 23:15:32 -0400
In-Reply-To: <p73przg10yp.fsf@bingen.suse.de> (Andi Kleen's message of "Tue\, 16 Oct 2007 00\:12\:46 +0200")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> The main use for me is to deal with dangling connections due to taking
>> network interfaces up&down with different IP addresses (typically the wlan0
>> interface where the IP is different because I've modes from an AP to
>> another).  Of course, maybe there's another way to solve this particular
>> problem, in case I'd like to hear about it as well.

> Long ago I did a 2.4 patch that solved exactly this problem. It introduced
> a new ifconfig flag "dynamic" and when a dynamic address went down
> all TCP connections originating from it were killed. It's still available
> in older SUSE releases. I might post a forward port later.

Actually, I'm pretty happy sometimes with the current behavior: if the
interface goes down and back up with the same AP within a short enough time,
it typically gets the same IP and the router's NAT table still has the TCP
connection live and things "just work".

So I'd want to kill the connections not when the interface goes down, but in
comes back up with a different IP.


        Stefan
